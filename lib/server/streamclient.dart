import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  WebSocketChannel client =
      WebSocketChannel.connect(Uri.parse("ws://10.0.178.155:5605"));
}
