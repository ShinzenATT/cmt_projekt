import 'package:cmt_projekt/api/stream_client.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';

class StreamModel {
  FlutterSoundPlayer? player;
  FlutterSoundRecorder? recorder;

  bool isInitiated = false;

  Client? c;
}
