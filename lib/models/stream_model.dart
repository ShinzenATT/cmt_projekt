import 'package:cmt_projekt/apis/stream_client.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';

/// A model used by [StreamVM] and similar which contains objects for streaming/listening
class StreamModel {
  /// The object that plays audio with the data it receives
  FlutterSoundPlayer? player;
  /// Instance of the recorder which returns sound data
  FlutterSoundRecorder? recorder;

  /// a bool that indicates if a stream is active or is listened to
  bool isInitiated = false;

  /// An instance of [StreamClient] that handles communication to stream server
  StreamClient? streamClient;
}
