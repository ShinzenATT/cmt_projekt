import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';

class Client {
  late WebSocketChannel client;
  FlutterSoundPlayer? _player = FlutterSoundPlayer();
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  late StreamSink<Food> foodSink;

  Client() {
    client = WebSocketChannel.connect(Uri.parse("ws://192.168.10.106:8080"));
  }

  void listen() {
  print("Am i listening????");
    client.stream.listen((event) {
      print("Stream running");
      playSound(event);
    });
  }

  Future<void> stopSound() async {
   await _player!.stopPlayer();
  }

  Future <void> playSound(event) async {
    await _player!.startPlayerFromStream(
        codec: Codec.pcm16,
        numChannels: 1,
        sampleRate: 48000,
    );
  }


  void sendData(data) {
    print("You alive?1");
    //print(data.runtimeType);
    print(data.runtimeType);

    //client.sink.add();
  }
}

void main() {
  Client c = Client();
}
