import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cmt_projekt/model/streammessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';

class Client {
  late WebSocketChannel client;
  FlutterSoundPlayer? _player = FlutterSoundPlayer();
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  StreamController<Food>? foodStreamController = StreamController<Food>.broadcast();

  Client(FlutterSoundPlayer? player) {
    print("hekki");
    _player = player;
    client = WebSocketChannel.connect(Uri.parse("ws://188.150.156.238:5605"));
  //  client.sink.add(jsonEncode(StreamMessage.host(uid: "2", channelType: "a")));
    foodStreamController!.stream.listen((event) {
      sendData(event);
    });
  }
  Future<void> _openPlayer() async {
    _player!.openAudioSession();
    await _player!.startPlayerFromStream
      (
        codec: Codec.pcm16, // Actually this is the only codec possible
        numChannels: 1, // Actually this is the only value possible. You cannot have several channels.
        sampleRate: 48100 // This parameter is very important if you want to specify your own sample rate
    );
  }
  void listen() {
  print("Am i listening????");
    client.stream.listen((event) {
      playSound(event);
    });
  }

  Future<void> stopSound() async {
   await _player!.stopPlayer();
  }

  Future <void> playSound(event) async {
    print("play data");
    Uint8List list = Uint8List.sublistView(event);
    _player!.foodSink!.add(FoodData(list));
  }


  void sendData(data) {
    print("You alive?1");
    //print(data.runtimeType);
    FoodData fd = data;
    client.sink.add(fd.data);
  }
}

void main() {
}
