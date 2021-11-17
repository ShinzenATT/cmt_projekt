import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  WebSocketChannel client =
       WebSocketChannel.connect(Uri.parse("ws://localhost:8080"));
  client.sink.add('Simon'.codeUnits);
  client.stream.listen((event) {
    print(event);
  });
}
