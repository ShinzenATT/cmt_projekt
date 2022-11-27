import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/model/stream_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants.dart';
import '../environment.dart';
import '../widgets/dialog_timer.dart';

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
    }, onDone: () {channelClosedDialog(context);});
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

  void channelClosedDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap a button!
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          child: Container(
            height: MediaQuery.of(context).size.height*0.4,
            width: MediaQuery.of(context).size.width*0.9,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.greenAccent,
                      Colors.blueAccent,
                    ])
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Sändningen är avslutad',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text('Byter till ny kanal om:',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const DialogTimer(time: 10,), //change textstyle in widget
                ElevatedButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.popUntil(context, (route) {
                        return route.settings.name == home;
                      });
                    }
                  },
                  child: const Text('Tillbaka till startsidan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Byt kanal',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}