import 'dart:io';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  ///En lista med alla anslutna klienter exklisive host.
  List<WebSocketChannel> clients = List.empty(growable: true);
  ///En host variabel.
  WebSocketChannel? host;

  var handler = webSocketHandler((WebSocketChannel webSocket) {
    ///Ifall hosten är null så skall den första anslutna socketen bli lagras i host.
    if(host==null){
      host = webSocket;
      ///Här ställer vi in så att såfort hosten skickar ett meddelande
      ///ska detta meddelande skickas till alla klienter.
      host!.stream.listen((message) async {
        if(message.runtimeType == String){
          print(message);
        }
        for(WebSocketChannel sock in clients) {
          sendData(sock, message);
        }
      },onDone: () {
        print("The host has left");
      }
      );
    } else {
      ///ifall host inte är null (redan är ansluten), lägg till nästa socket
      ///i listan.
      ///
      webSocket.stream.listen((event) { },onDone: (){
        print("A client has left");
      });
      clients.add(webSocket);
    }
    print("A new client has connected: $webSocket");
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

