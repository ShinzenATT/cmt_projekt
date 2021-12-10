import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cmt_projekt/model/streammessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';

import '../constants.dart';

class Client {
  late WebSocketChannel client;
  late FlutterSoundPlayer? _player;
  StreamController<Food>? foodStreamController = StreamController<Food>.broadcast();

  Client(FlutterSoundPlayer? player, String channelID, String intent, String user) {
    _player = player;
    client = WebSocketChannel.connect(Uri.parse("ws://188.150.156.238:5605"));
    if(intent == 'j') {
      client.sink.add(jsonEncode(StreamMessage.join(
          uid: user, channelType: "a", hostId: channelID)));
    } else {
      client.sink.add(jsonEncode(StreamMessage.host(uid: user, channelType: "a")));
    }
    foodStreamController!.stream.listen((event) {
      sendData(event);
    });
  }
  void listen(context) {
  print("Am i listening????");
    client.stream.listen((event) {
      playSound(event);
    },onDone: () {
      print(client.closeReason);
      Navigator.popUntil(context, ModalRoute.withName(home));
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
