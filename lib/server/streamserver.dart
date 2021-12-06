import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cmt_projekt/model/radiochannel.dart';
import 'package:cmt_projekt/model/streammessage.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  ///En lista med alla anslutna klienter exklisive host.
  List<WebSocketChannel> clients = List.empty(growable: true);
  ///En host variabel.
  WebSocketChannel? host;
  Map<String, RadioChannel> rooms = {};

  var handler = webSocketHandler((WebSocketChannel webSocket) {

    StreamController streamController = StreamController.broadcast();
    streamController.addStream(webSocket.stream);
    streamController.stream.asBroadcastStream().listen((event) {
      print(event.runtimeType);
      if(event.runtimeType == String) {
        StreamMessage message = StreamMessage.fromJson(jsonDecode(event));
        if(message.hostOrJoin == "h" && !rooms.containsKey(message.hostId)) {
          print("A new host ${message.uid} has connected: ${webSocket.hashCode}");
          rooms[message.hostId] = RadioChannel(streamController,message.hostId);

        }else if (message.hostOrJoin == "j" && rooms.containsKey(message.hostId)) {
          print("A new client ${message.uid} has connected: ${webSocket.hashCode} and wants to join room ${message.hostId}");
          RadioChannel? room = rooms[message.hostId];
          room!.connectedAudioClients.add(webSocket);
        }
      }
    });
  });
  shelf_io.serve(handler, '192.168.0.2', 5605).then((server) {
    print('Serving at ws://${server.address.host}:${server.port}');
  });
}
///En async funktion som sänder given data till given socket.
Future<void> sendData(WebSocketChannel client, message) async {
  print("sending");
  client.sink.add(message);
}

