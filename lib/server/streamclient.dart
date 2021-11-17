import 'dart:typed_data';

import 'package:sound_stream/sound_stream.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Client {
  late WebSocketChannel client;
  PlayerStream _player = PlayerStream();


  Client() {
    client = WebSocketChannel.connect(Uri.parse("ws://192.168.77.128:8080"));
    _player.initialize();
  }

  void listen() {
    client.stream.listen((event) {
      playSound(event);
    });
  }

  void playSound(event) async {
    await _player.start();

    if (event.isNotEmpty) {
      await _player.writeChunk(event);
    }
  }

  void sendData(data) {
    client.sink.add(data);

  }
}

void main() {
  Client c = Client();
}
