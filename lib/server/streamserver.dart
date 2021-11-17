import 'dart:io';

void main() async {
  ServerSocket server = await ServerSocket.bind("10.0.178.155", 5605);
  print(InternetAddress.anyIPv4);
  HttpServer httpserver = HttpServer.listenOn(server);
  server.listen((event) {
    print(event);
  });
}
