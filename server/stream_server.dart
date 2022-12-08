import 'dart:async';
import 'dart:convert';

import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/models/query_model.dart';
import 'package:cmt_projekt/models/radio_channel_model.dart';
import 'package:cmt_projekt/models/streammessage_model.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:cmt_projekt/apis/database_api.dart';

void main() {
  StreamServer();
}

/// A class for handling websocket connections meant for streaming
class StreamServer {
  ///A map with all connected users.
  Map<WebSocketChannel, StreamController> connectedUsers = {};

  ///A map with all the rooms
  Map<String, RadioChannel> rooms = {};

  /// Setups a websocket server at port 5605 using [handleIncomingConnections] as the connection handler
  StreamServer() {
    var handler = webSocketHandler(handleIncomingConnections);
    shelf_io.serve(handler, '0.0.0.0', 5605).then((server) {
      logger.i(
          'Stream server serving at ws://${server.address.host}:${server.port} \n'
          '(0.0.0.0 means all ips are accepted, which includes localhost)');
    });
  }

  /// This method is the primary handler for connections not associated with a room.
  /// It will check the intent pf the decoded json and sends to the relevant method based on that intent.
  ///
  /// If the intent is **j** then the [initClientStream] is called while for **h**
  /// [initHostStream] is called.
  void handleIncomingConnections(WebSocketChannel webSocket) async {
    //Sets up so that clients that connect gets their own StreamController and is added to the list of connectedUsers.
    connectedUsers[webSocket] = StreamController.broadcast();

    //Sets up a listen function that sends incoming data from the web socket to the StreamController.
    //The onDone function is called when the web socket connection is closed and handles the host/clients close methods.
    webSocket.stream.listen((event) {
      connectedUsers[webSocket]!.sink.add(event);
    }, onDone: () {
      connectedUsers[webSocket]!.close();
    });

    //The first listen function to the StreamController.
    //Here the connected web socket is checked whether it is a host or client and calls the correct function accordingly.
    connectedUsers[webSocket]!.stream.asBroadcastStream().listen((event) {
      if (event.runtimeType == String) {
        StreamMessage message = StreamMessage.fromJson(jsonDecode(event));
        if (message.intent == "h" && !rooms.containsKey(message.hostId)) {
          initHostStream(message, webSocket);
        } else if (message.intent == "j" && rooms.containsKey(message.hostId)) {
          initClientStream(message, webSocket);
        } else if (message.intent == "j" &&
            !rooms.containsKey(message.hostId)) {
          webSocket.sink.close(4400, "room does not exist");
        }
      }
    });
  }

  ///This function is called when a host connects to the server and creates a radio channel with the host id.
  ///Also sets up a extra stream internally for the host-web socket for creating multiple listen functions.
  /// The new host stream will be added to [rooms] with host id as its key.
  Future<void> initHostStream(
      StreamMessage message, WebSocketChannel webSocket) async {
    logger.v(
        "A new host ${message.uid} has connected: Category: ${message.category}, Name: ${message.channelName}");


    final Map<String, dynamic> res;
    try {
      ///Adds the radiochannel to the database if it doesn't already exist. After that the radio channel is toggled as online.
      res = await DatabaseApi.postRequest(
          '/channel',
          QueryModel.createChannel(
              uid: message.uid,
              channelname: message.channelName,
              category: message.category
          ));
    } on HttpReqException catch(e){
      logger.e(e.message, e);
      webSocket.sink.close(1011, e.message);
      return;
    } catch(e){
      logger.e(e.toString(), e);
      webSocket.sink.close(1011, e.toString());
      return;
    }

    RadioChannel channel = RadioChannel(webSocket, message.hostId!);

    ///Adds the radio channel to the list of all radio channels.
    rooms[message.hostId!] = channel;

    sendData(webSocket, jsonEncode(res));

    ///Sets up a listen function specifically for the host. It is used to let the host send messages to all clients connected to the hosts radio channel.
    ///OnDone disconnects all clients from the radio channel and removes the channel from the list.
    connectedUsers[webSocket]!.stream.asBroadcastStream().listen(
        (message) async {
          // forwards all binary (audio) data to all listening clients
      if (message.runtimeType != String) {
        for (WebSocketChannel sock in channel.connectedAudioClients) {
          sendData(sock, message);
        }
      } else { // decodes json messages, updates channel info and forwards new channel info to all clients
        StreamMessage msg = StreamMessage.fromJson(jsonDecode(message));
        if (msg.intent == "u") {
          dynamic res;
          try {
            res = await DatabaseApi.postRequest(
                '/channel',
                QueryModel.createChannel(
                    uid: msg.uid,
                    channelname: msg.channelName,
                    category: msg.category));
          } on HttpReqException catch (e) {
            logger.e(e.message, e);
          }  catch (e) {
            logger.e(e.toString(), e);
          }

          if (res != null) {
            res = jsonEncode(res);

            // sends updated channel information to all the listening clients/host
            sendData(webSocket, res);
            for (WebSocketChannel sock in channel.connectedAudioClients) {
              sendData(sock, res);
            }
          }
        }
      }
    }, onDone: () async { // disconnects all clients when host is disconnected
      for (WebSocketChannel client in channel.connectedAudioClients) {
        client.sink.close(1000, "Room ${channel.channelId} closed");
      }
      logger.v("Channel ${message.uid} closed");
      rooms.remove(channel.channelId);
      try {
        await DatabaseApi.deleteRequest(
            '/channel',
            QueryModel.channelOffline(uid: channel.channelId)
        );
      } on HttpReqException catch(e){
        logger.e(e.message, e);
      } catch (e) {
        logger.e(e.toString(), e);
      }

      try {
        await DatabaseApi.deleteRequest(
            '/channel/viewers/all',
            QueryModel.delViewers(channelid: message.hostId)
        );
      } on HttpReqException catch(e){
        logger.e(e.message, e);
      } catch (e) {
        logger.e(e.toString(), e);
      }

      connectedUsers.remove(webSocket);
    });
  }

  ///This function is called when a client connects to the server and wants to join a radio channel.
  ///Also sets up a extra stream internally for the client-web socket for creating multiple listen functions.
  Future<void> initClientStream(StreamMessage message, WebSocketChannel webSocket) async {
    logger.v(
        "A new client ${message.uid} has connected: and wants to join room ${message.hostId}");

    ///Picks out the desired radio channel from the list of all radio channels.
    RadioChannel room = rooms[message.hostId]!;

    dynamic res;
    try {
      ///Adds the viewer of said radio channel to the database.
      res = await DatabaseApi.postRequest('/channel/viewers',
          QueryModel.addViewers(channelid: message.hostId, uid: message.uid)
      );
    } on HttpReqException catch(e){
      logger.e(e.message, e);
      webSocket.sink.close(1011, e.message);
      return;
    } catch(e){
      logger.e(e.toString(), e);
      webSocket.sink.close(1011, e.toString());
      return;
    }

    ///Adds the client to the radio channels list of all connected clients.
    //room!.connectedAudioClients.add(webSocket);
    room.addAudioViewer(webSocket);

    res = jsonEncode(res);

    // sends updated channel information to all the listening clients/host
    sendData(room.streamAudioHost, res);
    for (WebSocketChannel sock in room.connectedAudioClients) {
      sendData(sock, res);
    }

    ///Sets up a listen function with the sole purpose of handling disconnecting clients with onDone.
    connectedUsers[webSocket]!.stream.asBroadcastStream().listen((event) {},
        onDone: () async {
      logger.v("Client ${message.uid} left ${message.hostId}");

      dynamic res;
      try {
        res = await DatabaseApi.deleteRequest(
            '/channel/viewers',
            QueryModel.delViewer(
                channelid: message.hostId, uid: message.uid));
      }  on HttpReqException catch (e){
        logger.e(e.message, e);
      } catch (e){
        logger.e(e.toString(), e);
      }

      room.disconnectAudioViewer(webSocket);
      webSocket.sink.close(res != null ? 1000: 1011, "lämnade servern");
      connectedUsers.remove(webSocket);

      if(res !=  null) {
        res = jsonEncode(res);

        // sends updated channel information to all the listening clients/host
        sendData(room.streamAudioHost, res);
        for (WebSocketChannel sock in room.connectedAudioClients) {
          sendData(sock, res);
        }
      }
    });
  }

  ///An asynchronous function that given data to the given web socket.
  Future<void> sendData(WebSocketChannel client, message) async {
    client.sink.add(message);
  }
}
