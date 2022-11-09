import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/model/stream_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants.dart';
import '../envioroment.dart';

class Client {
  late WebSocketChannel client;
  late FlutterSoundPlayer? _player;
  StreamController<Food>? foodStreamController =
      StreamController<Food>.broadcast();

  Client(FlutterSoundPlayer? player) {
    _player = player;
    client = WebSocketChannel.connect(Uri.parse(serverConnection));

    if (Prefs().getIntent() == "j") {
      debugPrint(Prefs().getIntent().toString());
      client.sink.add(jsonEncode(StreamMessage.join(
          uid: Prefs().storedData.get("uid").toString(),
          channelType: "a",
          hostId: Prefs().storedData.get("joinChannelID").toString())));
    } else {
      client.sink.add(jsonEncode(StreamMessage.host(
        uid: Prefs().storedData.get("uid").toString(),
        channelType: "a",
        category: Prefs().storedData.getString("category"),
        channelName: Prefs().storedData.getString("channelName"),
      )));
    }
    foodStreamController!.stream.listen((event) {
      sendData(event);
    });
  }
  void listen(context) {
    client.stream.listen((event) {
      playSound(event);
    }, onDone: () {
      if (Navigator.canPop(context)) {
        Navigator.popUntil(context, (route) {
          return route.settings.name == home;
        });
      }
    });
  }

  Future<void> stopSound() async {
    await _player!.stopPlayer();
  }

  Future<void> playSound(event) async {
    Uint8List list = Uint8List.sublistView(event);
    _player!.foodSink!.add(FoodData(list));
  }

  void sendData(data) {
    FoodData fd = data;
    client.sink.add(fd.data);
  }
}
