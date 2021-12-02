import 'package:cmt_projekt/model/streammodel.dart';
import 'package:cmt_projekt/server/streamclient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
typedef Fn = void Function();
class StreamViewModel with ChangeNotifier{
  StreamModel smodel = StreamModel();

  void startup(){
    smodel.c = Client(smodel.player);
    init().then((value) {
      smodel.isInited = true;
      smodel.c.listen();
    });
  }

  Future<void> init() async {
    await smodel.recorder!.openAudioSession(
      device: AudioDevice.blueToothA2DP,
      audioFlags: allowHeadset | allowEarPiece | allowBlueToothA2DP,
      category: SessionCategory.playAndRecord,
    );
    await smodel.player!.openAudioSession(
      device: AudioDevice.blueToothA2DP,
      audioFlags: allowHeadset | allowEarPiece | allowBlueToothA2DP,
      category: SessionCategory.playAndRecord,
    );
  }


  Future<void> release() async {
    await stopPlayer();
    await smodel.player!.closeAudioSession();
    smodel.player = null;

    await stopRecorder();
    await smodel.recorder!.closeAudioSession();
    smodel.recorder = null;
  }

  @override
  void dispose() {
    release();
    super.dispose();
  }

  Future<void>? stopRecorder() {
    if (smodel.recorder != null) {
      return smodel.recorder!.stopRecorder();
    }
    return null;
  }

  Future<void>? stopPlayer() {
    if (smodel.player != null) {
      return smodel.player!.stopPlayer();
    }
    return null;
  }

  Future<void> addStream() async {
    Stream<Food> stream;
  }

  Future<void> record() async {


    await smodel.player!.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 44000,
    );

    await smodel.recorder!.startRecorder(
      codec: Codec.pcm16,
      toStream: smodel.c.foodStreamController!.sink, // ***** THIS IS THE LOOP !!! *****
      sampleRate: 44000,
      numChannels: 1,
    );
    notifyListeners();
  }

  Future<void> stop() async {
    if (smodel.recorder != null) {
      await smodel.recorder!.stopRecorder();
    }
    if (smodel.player != null) {
      //   await _player!.stopPlayer();
    }
    notifyListeners();
  }

  Fn? getRecFn() {
    if (smodel.isInited) {
      return null;
    }
    return smodel.recorder!.isRecording ? stop : record;
  }
}