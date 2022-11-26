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
      showDialog(
        context: context,
        barrierDismissible: false, // user must tap a button!
        builder: (context) {
          return AlertDialog(
            title: const Text('Sändningen är avslutad',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            content: Builder(
              builder: (context) {
                return Container(
                  height: MediaQuery.of(context).size.height*0.1,
                  width: MediaQuery.of(context).size.width*0.9,
                  child: Column(
                    children: const [
                      Text('Byter till ny kanal om:',
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      DialogTimer(time: 10,), //change fontsize in widget
                    ],
                  ),
                );
              },
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
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
                  ),
                ),
              ),
            ],
          );
        },
      );
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

///Widget that displays a countdown from the given duration to 0 when initialized
///Required key time sets the duration in seconds
class DialogTimer extends StatefulWidget {
  final int time;
  const DialogTimer({Key? key, required this.time}) : super(key: key);

  @override
  State<DialogTimer> createState() => _DialogTimerState();
}

class _DialogTimerState extends State<DialogTimer> {
  Timer? timer;
  late Duration alertDuration;//start time for the countdown

  @override
  void initState() {
    super.initState();
    alertDuration = Duration(seconds: widget.time);

    /// Periodic timer is created when widget DialogTimer is initialized
    timer = Timer.periodic(
      const Duration(seconds: 1), //call setCountDown every second
            (_) => setCountDown()
    );
  }

  /// cancel the timer when widget is disposed,
  /// to avoid any active timer that is not executed yet
  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = alertDuration.inSeconds;
    return Text('$seconds',
      style: const TextStyle(
        fontSize: 30,
      ),
    );
  }

  /// Reduces the alerDuration, i.e time displayed, each time it's called.
  /// Until it reached zero, then timer is cancelled.
  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = alertDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        timer!.cancel();
      } else {
        alertDuration = Duration(seconds: seconds);
      }
    });
  }
}

