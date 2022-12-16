import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cmt_projekt/apis/prefs.dart';
import 'package:cmt_projekt/models/channel_data_model.dart';
import 'package:cmt_projekt/models/streammessage_model.dart';
import 'package:cmt_projekt/widgets/channel_closed_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../environment.dart';

/// A Class for handling a websocket stream to the server
class StreamClient {
  /// The websocket connection to the stream server
  late WebSocketChannel client;
  /// The player object that plays sound
  late FlutterSoundPlayer? _player;
  /// A stream controller used by recorders to forward data to the websocket connection
  StreamController<Food>? foodStreamController =
      StreamController<Food>.broadcast();
  /// A stream controller for forwarding updated channel data to various pages.
  StreamController<ChannelDataModel> msgController =
      StreamController<ChannelDataModel>.broadcast();

  /// Initiates the Flutter sound player and setups a connection to the server
  StreamClient(FlutterSoundPlayer? player) {
    _player = player;
    client = WebSocketChannel.connect(Uri.parse(serverConnection));

    if (Prefs().getIntent() == "j") { // sends a json msg to server on which host to join/listen
      debugPrint(Prefs().getIntent().toString());
      client.sink.add(jsonEncode(
          StreamMessage.join(
              uid: Prefs().storedData.get("uid").toString(),
              channelType: "a",
              hostId: Prefs().storedData.get("joinChannelID").toString()
          ).toMap()
      ));
    } else { // sends a json msg to server with intent to host
      client.sink.add(jsonEncode(
          StreamMessage.host(
            channelType: "a",
            channelData: ChannelDataModel(
                channelname: Prefs().storedData.getString("channelName")!,
                channelid: Prefs().storedData.get("uid").toString(),
                category: Prefs().storedData.getString("category")!
            ),
          ).toMap()
      ));
    }

    // when the stream gets recording data then send it to the stream server
    foodStreamController!.stream.listen((event) { sendData(event as FoodData); });
  }

  /// A handler for receiving data from the server.
  /// It differentiates between string and binary data so strings are json decoded and sent to [msgController].
  /// While binary (sound) data is handled by the [playSound] method.
  void listen(context) {
    client.stream.listen((event) {
      if(event.runtimeType == String){
        final msg = ChannelDataModel.parseMap(jsonDecode(event));
        msgController.sink.add(msg);
      } else {
        playSound(event);
      }
    }, onDone: () {
      // 1005 stands for "closed with no exit status" so show only when server gives exit code
      if(client.closeCode != 1005) {
        channelClosedDialog(context);
      }
    });
  }

  ///Stops audio playback, see [FlutterSoundPlayer.stopPlayer].
  Future<void> stopSound() async {
    await _player!.stopPlayer();
  }

  /// Plays audio data provided and adds to the players foodsink. See [FlutterSoundPlayer.foodSink].
  Future<void> playSound(TypedData event) async {
    Uint8List list = Uint8List.sublistView(event);
    _player!.foodSink!.add(FoodData(list));
  }

  /// Sends binary audio data to the server
  void sendData(FoodData data) {
    client.sink.add(data.data);
  }

  /// Sends a json message to the server with intent to update channel info.
  sendUpdate(StreamMessage msg){
    msg.intent = "u";
    client.sink.add(jsonEncode(msg.toMap()));
  }

  /// Shows a [ChannelClosedDialog]
  void channelClosedDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap a button!
      builder: const ChannelClosedDialog().build,
    );
  }
}
