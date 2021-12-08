import 'dart:typed_data';

import 'package:cmt_projekt/server/streamclient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';

class StreamModel {
  FlutterSoundPlayer? player = FlutterSoundPlayer();
  FlutterSoundRecorder? recorder = FlutterSoundRecorder();
  TextEditingController hostID = TextEditingController();

  bool isInited = false;

  late Client c;
}
