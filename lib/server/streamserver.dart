import 'dart:io';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  List<WebSocketChannel> clients = List.empty(growable: true);


  var handler = webSocketHandler((webSocket) {
    clients.add(webSocket);
    print("A new client has connected: $webSocket");
    webSocket.stream.listen((message) {
     // webSocket.sink.add("echo $message");
      print(message);
      for(WebSocketChannel sock in clients) {
        sock.sink.add(message);
      }
    });
  });

  shelf_io.serve(handler, '192.168.10.106', 8080).then((server) {
    print('Serving at ws://${server.address.host}:${server.port}');
  });
}
