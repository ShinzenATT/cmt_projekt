import 'dart:async';
import 'dart:convert';

import 'package:cmt_projekt/model/query_model.dart';
import 'package:cmt_projekt/model/radio_channel.dart';
import 'package:cmt_projekt/model/stream_message.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:cmt_projekt/api/database_api.dart';

import '../constants.dart';

void main() async {
  ///A map with all connected users.
  Map<WebSocketChannel, StreamController> connectedUsers = {};

  ///A map with all the rooms
  Map<String, RadioChannel> rooms = {};

  ///A instance of DatabaseAPI to enable communication with the database.
  DatabaseApi database = DatabaseApi();

  ///This function is called when a host connects to the server and creates a radio channel with the host id.
  ///Also sets up a extra stream internally for the host-web socket for creating multiple listen functions.
  void initHostStream(StreamMessage message, webSocket) {
    print(
        "A new host ${message.uid} has connected: Category: ${message.category}, Name: ${message.channelName}");

    ///Creates a radio channel
    RadioChannel channel = RadioChannel(webSocket, message.hostId!);

    ///Adds the radio channel to the list of all radio channels.
    rooms[message.hostId!] = channel;

    ///Adds the radiochannel to the database if it doesn't already exist. After that the radio channel is toggled as online.
    database.sendRequest(QueryModel.createChannel(
        uid: message.uid,
        channelName: message.channelName,
        category: message.category));

    ///Sets up a listen function specifically for the host. It is used to let the host send messages to all clients connected to the hosts radio channel.
    ///OnDone disconnects all clients from the radio channel and removes the channel from the list.
    connectedUsers[webSocket]!.stream.asBroadcastStream().listen((message) {
      if (message.runtimeType != String) {
        for (WebSocketChannel sock in channel.connectedAudioClients) {
          sendData(sock, message);
        }
      }
    }, onDone: () {
      for (WebSocketChannel client in channel.connectedAudioClients) {
        client.sink.close(100005, "Rum ${channel.channelId} stängdes");
      }
      print("Channel ${message.channelName} closed");
      rooms.remove(channel.channelId);
      database.sendRequest(QueryModel.channelOffline(uid: channel.channelId));
      database.sendRequest(QueryModel.delViewers(channelid: message.hostId));
      connectedUsers.remove(webSocket);
    });
  }

  ///This function is called when a client connects to the server and wants to join a radio channel.
  ///Also sets up a extra stream internally for the client-web socket for creating multiple listen functions.
  void initClientStream(StreamMessage message, webSocket) {
    print(
        "A new client ${message.uid} has connected: and wants to join room ${message.hostId}");

    ///Picks out the desired radio channel from the list of all radio channels.
    RadioChannel? room = rooms[message.hostId];

    ///Adds the client to the radio channels list of all connected clients.
    //room!.connectedAudioClients.add(webSocket);
    room!.addAudioViewer(webSocket);

    ///Adds the viewer of said radio channel to the database.
    database.sendRequest(
        QueryModel.addViewers(channelid: message.hostId, uid: message.uid));

    ///Sets up a listen function with the sole purpose of disconnecting clients with onDone.
    connectedUsers[webSocket]!.stream.asBroadcastStream().listen((event) {},
        onDone: () {
      print("Client ${message.uid} left ${message.hostId}");
      database.sendRequest(QueryModel.delViewer(
          channelid: message.hostId, uid: message.uid)); // -
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
  shelf_io.serve(handler, localServer, 5605).then((server) {
    print('Serving at ws://${server.address.host}:${server.port}');
  });
}

///An asynchronous function that given data to the given web socket.
Future<void> sendData(WebSocketChannel client, message) async {
  client.sink.add(message);
}
