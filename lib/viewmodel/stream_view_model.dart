import 'package:cmt_projekt/model/streammodel.dart';
import 'package:cmt_projekt/server/streamclient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:cmt_projekt/api/prefs.dart';
typedef Fn = void Function();

class StreamViewModel with ChangeNotifier {
  StreamModel smodel = StreamModel();

  void startup(context){
    smodel.c = Client(context);
    init().then((value) {
      smodel.isInited = true;
      smodel.c.listen(context);
    });
  }

  Future<bool> closeClient() async {
    smodel.player!.stopPlayer();
    smodel.recorder!.stopRecorder();
    smodel.c.stopSound();
    smodel.isInited = false;

    smodel.c.client.sink.close();
    return true;
  }

  TextEditingController get hostID => smodel.hostID;

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
    await smodel.player!.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 44000,
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

  void getRecFn() {
    if (!smodel.isInited) {
      return null;
    }
    print("hello" + " "+ "${smodel.recorder!.isRecording}");
    if(smodel.recorder!.isRecording){
      stop();
    }else {
      record();
    };
  }
}
