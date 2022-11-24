import 'dart:async';
import 'dart:convert';

import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/model/query_model.dart';
import 'package:cmt_projekt/model/radio_channel.dart';
import 'package:cmt_projekt/model/stream_message.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:cmt_projekt/api/database_api.dart';

void main() async {
  ///A map with all connected users.
  Map<WebSocketChannel, StreamController> connectedUsers = {};

  ///A map with all the rooms
  Map<String, RadioChannel> rooms = {};

  ///A instance of DatabaseAPI to enable communication with the database.
  DatabaseApi database = DatabaseApi();

  ///This function is called when a host connects to the server and creates a radio channel with the host id.
  ///Also sets up a extra stream internally for the host-web socket for creating multiple listen functions.
  Future<void> initHostStream(StreamMessage message, webSocket) async {
    logger.v("A new host ${message.uid} has connected: Category: ${message.category}, Name: ${message.channelName}");

    ///Creates a radio channel
    RadioChannel channel = RadioChannel(webSocket, message.hostId!);

    ///Adds the radio channel to the list of all radio channels.
    rooms[message.hostId!] = channel;

    ///Adds the radiochannel to the database if it doesn't already exist. After that the radio channel is toggled as online.
    await database.postRequest( '/channel' ,QueryModel.createChannel(
        uid: message.uid,
        channelname: message.channelName,
        category: message.category));

    ///Sets up a listen function specifically for the host. It is used to let the host send messages to all clients connected to the hosts radio channel.
    ///OnDone disconnects all clients from the radio channel and removes the channel from the list.
    connectedUsers[webSocket]!.stream.asBroadcastStream().listen((message) {
      if (message.runtimeType != String) {
        for (WebSocketChannel sock in channel.connectedAudioClients) {
          sendData(sock, message);
        }
      }
    }, onDone: () async {
      for (WebSocketChannel client in channel.connectedAudioClients) {
        client.sink.close(100005, "Rum ${channel.channelId} stängdes");
      }
      logger.v("Channel ${message.uid} closed");
      rooms.remove(channel.channelId);
      await database.deleteRequest('/channel', QueryModel.channelOffline(uid: channel.channelId));
      await database.deleteRequest('/channel/viewers/all', QueryModel.delViewers(channelid: message.hostId));
      connectedUsers.remove(webSocket);
    });
  }

  ///This function is called when a client connects to the server and wants to join a radio channel.
  ///Also sets up a extra stream internally for the client-web socket for creating multiple listen functions.
  Future<void> initClientStream(StreamMessage message, webSocket) async {
    logger.v(
        "A new client ${message.uid} has connected: and wants to join room ${message.hostId}");

    ///Picks out the desired radio channel from the list of all radio channels.
    RadioChannel? room = rooms[message.hostId];

    ///Adds the client to the radio channels list of all connected clients.
    //room!.connectedAudioClients.add(webSocket);
    room!.addAudioViewer(webSocket);

    ///Adds the viewer of said radio channel to the database.
    await database.postRequest(
        '/channel/viewers',
        QueryModel.addViewers(channelid: message.hostId, uid: message.uid)
    );

    ///Sets up a listen function with the sole purpose of disconnecting clients with onDone.
    connectedUsers[webSocket]!.stream.asBroadcastStream().listen((event) {},
        onDone: () async {
      logger.v("Client ${message.uid} left ${message.hostId}");
      await database.deleteRequest(
          '/channel/viewers',
          QueryModel.delViewer(channelid: message.hostId, uid: message.uid)
      ); // -
      room.disconnectAudioViewer(webSocket);
      webSocket.sink.close(10006, "lämnade servern");
      connectedUsers.remove(webSocket);
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
        if (message.hostOrJoin == "h" && !rooms.containsKey(message.hostId)) {
          initHostStream(message, webSocket);
        } else if (message.hostOrJoin == "j" &&
            rooms.containsKey(message.hostId)) {
          initClientStream(message, webSocket);
        } else if (message.hostOrJoin == "j" &&
            !rooms.containsKey(message.hostId)) {
          webSocket.sink.close(100009, "rummet finns inte");
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
