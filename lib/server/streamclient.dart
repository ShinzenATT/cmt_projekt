import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';

class Client {
  late WebSocketChannel client;
  FlutterSoundPlayer _player = FlutterSoundPlayer();
  StreamController _stream = StreamController();


  Client() {
    client = WebSocketChannel.connect(Uri.parse("ws://192.168.10.106:8080"));
  }

  void listen() {
  print("Am i listening????");
    client.stream.listen((event) {
      playSound(event);
    });
  }

  void playSound(event) async {
    //_player.feedFromStream();
    await _player.startPlayerFromStream(
        codec: Codec.pcm16, // Actually this is the only codec possible
        numChannels: 1, // Actually this is the only value possible. You cannot have several channels.
        sampleRate: 48100 // This parameter is very important if you want to specify your own sample rate
    );
  }

  void sendData(data, StreamController) {
    print("You alive?1");
    _stream = StreamController;
    client.sink.add(data);
  }
}

void main() {
  Client c = Client();
}
