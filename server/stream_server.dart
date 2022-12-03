import 'dart:async';
import 'dart:convert';

import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/models/query_model.dart';
import 'package:cmt_projekt/models/channel_model.dart';
import 'package:cmt_projekt/models/streammessage_model.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:cmt_projekt/apis/database_api.dart';

void main() async {
  ///A map with all connected users.
  Map<WebSocketChannel, StreamController> connectedUsers = {};

  ///A map with all the rooms
  Map<String, RadioChannel> rooms = {};

  ///This function is called when a host connects to the server and creates a radio channel with the host id.
  ///Also sets up a extra stream internally for the host-web socket for creating multiple listen functions.
  Future<void> initHostStream(StreamMessage message, WebSocketChannel webSocket) async {
    logger.v("A new host ${message.uid} has connected: Category: ${message.category}, Name: ${message.channelName}");

    ///Creates a radio channel
    RadioChannel channel = RadioChannel(webSocket, message.hostId!);

    ///Adds the radio channel to the list of all radio channels.
    rooms[message.hostId!] = channel;

    ///Adds the radiochannel to the database if it doesn't already exist. After that the radio channel is toggled as online.
    final res = await DatabaseApi.postRequest( '/channel' ,QueryModel.createChannel(
        uid: message.uid,
        channelname: message.channelName,
        category: message.category
    ));
    sendData(webSocket, jsonEncode(res));

    ///Sets up a listen function specifically for the host. It is used to let the host send messages to all clients connected to the hosts radio channel.
    ///OnDone disconnects all clients from the radio channel and removes the channel from the list.
    connectedUsers[webSocket]!.stream.asBroadcastStream().listen((message) async {
      if (message.runtimeType != String) {
        for (WebSocketChannel sock in channel.connectedAudioClients) {
          sendData(sock, message);
        }
      } else {
        StreamMessage msg = StreamMessage.fromJson(jsonDecode(message));
        if(msg.intent == "u"){
          var res = await DatabaseApi.postRequest('/channel', QueryModel.createChannel(
              uid: msg.uid,
              channelname: msg.channelName,
              category: msg.category
          ));

          res = jsonEncode(res);

          sendData(webSocket, res);
          for(WebSocketChannel sock in channel.connectedAudioClients){
            sendData(sock, res);
          }

        }
      }
    }, onDone: () async {
      for (WebSocketChannel client in channel.connectedAudioClients) {
        client.sink.close(1000, "Rum ${channel.channelId} stängdes");
      }
      logger.v("Channel ${message.uid} closed");
      rooms.remove(channel.channelId);
      await DatabaseApi.deleteRequest('/channel', QueryModel.channelOffline(uid: channel.channelId));
      await DatabaseApi.deleteRequest('/channel/viewers/all', QueryModel.delViewers(channelid: message.hostId));
      connectedUsers.remove(webSocket);
    });
  }

  ///This function is called when a client connects to the server and wants to join a radio channel.
  ///Also sets up a extra stream internally for the client-web socket for creating multiple listen functions.
  Future<void> initClientStream(StreamMessage message, webSocket) async {
    logger.v(
        "A new client ${message.uid} has connected: and wants to join room ${message.hostId}");

    ///Picks out the desired radio channel from the list of all radio channels.
    RadioChannel room = rooms[message.hostId]!;

    ///Adds the client to the radio channels list of all connected clients.
    //room!.connectedAudioClients.add(webSocket);
    room.addAudioViewer(webSocket);

    ///Adds the viewer of said radio channel to the database.
    var res = await DatabaseApi.postRequest(
        '/channel/viewers',
        QueryModel.addViewers(channelid: message.hostId, uid: message.uid)
    );

    res["total"] = room.connectedAudioClients.length;
    res = jsonEncode(res);

    sendData(room.streamAudioHost, res);
    for(WebSocketChannel sock in room.connectedAudioClients){
      sendData(sock, res);
    }

    ///Sets up a listen function with the sole purpose of disconnecting clients with onDone.
    connectedUsers[webSocket]!.stream.asBroadcastStream().listen((event) {},
        onDone: () async {
      logger.v("Client ${message.uid} left ${message.hostId}");
      var res = await DatabaseApi.deleteRequest(
          '/channel/viewers',
          QueryModel.delViewer(channelid: message.hostId, uid: message.uid)
      ); // -
      room.disconnectAudioViewer(webSocket);
      webSocket.sink.close(10006, "lämnade servern");
      connectedUsers.remove(webSocket);

      res["total"] = room.connectedAudioClients.length;
      res = jsonEncode(res);

      sendData(room.streamAudioHost, res);
      for(WebSocketChannel sock in room.connectedAudioClients){
        sendData(sock, res);
      }
    });
  }

  var handler = webSocketHandler((WebSocketChannel webSocket) {
    ///Sets up so that clients that connect gets their own StreamController and is added to the list of connectedUsers.
    connectedUsers[webSocket] = StreamController.broadcast();

    ///Sets up a listen function that sends incoming data from the web socket to the StreamController.
    ///The onDone function is called when the web socket connection is closed and handles the host/clients close methods.
    webSocket.stream.listen((event) {
      connectedUsers[webSocket]!.sink.add(event);
    }, onDone: () {
      connectedUsers[webSocket]!.close();
    });

    ///The first listen function to the StreamController. Here the connected web socket is checked whether it is a host or client and calls the correct function accordingly.
    connectedUsers[webSocket]!.stream.asBroadcastStream().listen((event) {
      if (event.runtimeType == String) {
        StreamMessage message = StreamMessage.fromJson(jsonDecode(event));
        if (message.intent == "h" && !rooms.containsKey(message.hostId)) {
          initHostStream(message, webSocket);
        } else if (message.intent == "j" &&
            rooms.containsKey(message.hostId)) {
          initClientStream(message, webSocket);
        } else if (message.intent == "j" &&
            !rooms.containsKey(message.hostId)) {
          webSocket.sink.close(4400, "rummet finns inte");
        }
      }
    });
  });
  shelf_io.serve(handler, '0.0.0.0', 5605).then((server) {
    logger.i('Stream server serving at ws://${server.address.host}:${server.port} \n'
        '(0.0.0.0 means all ips are accepted, which includes localhost)');
  });
}

///An asynchronous function that given data to the given web socket.
Future<void> sendData(WebSocketChannel client, message) async {
  client.sink.add(message);
}
