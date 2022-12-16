import 'package:cmt_projekt/models/channel_data_model.dart';
import 'package:cmt_projekt/models/stream_model.dart';
import 'package:cmt_projekt/apis/stream_client.dart';
import 'package:cmt_projekt/models/streammessage_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import '../apis/prefs.dart';

typedef Fn = void Function();

class StreamVM with ChangeNotifier {
  StreamModel streamModel = StreamModel();

  void startup(context) {
    streamModel.player = FlutterSoundPlayer();
    streamModel.recorder = FlutterSoundRecorder();
    streamModel.streamClient = StreamClient(streamModel.player);
    init().then((value) {
      streamModel.isInitiated = true;
      streamModel.streamClient!.listen(context);
    });
  }

  Future<bool> closeClient() async {
    if (streamModel.streamClient != null) {
      streamModel.player!.stopPlayer();
      streamModel.recorder!.stopRecorder();
      streamModel.streamClient!.stopSound();
      streamModel.isInitiated = false;
      streamModel.streamClient!.client.sink.close();
      streamModel.streamClient = null;
    }
    return true;
  }

  Future<void> init() async {
    await streamModel.recorder!.openAudioSession(
      device: AudioDevice.blueToothA2DP,
      audioFlags: allowHeadset | allowEarPiece | allowBlueToothA2DP,
      category: SessionCategory.playAndRecord,
    );
    await streamModel.player!.openAudioSession(
      device: AudioDevice.blueToothA2DP,
      audioFlags: allowHeadset | allowEarPiece | allowBlueToothA2DP,
      category: SessionCategory.playAndRecord,
    );
    await streamModel.player!.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 44000,
    );
  }

  Future<void> release() async {
    await stopPlayer();
    await streamModel.player!.closeAudioSession();
    streamModel.player = null;

    await stopRecorder();
    await streamModel.recorder!.closeAudioSession();
    streamModel.recorder = null;
  }

  @override
  void dispose() {
    release();
    super.dispose();
  }

  Future<void>? stopRecorder() {
    if (streamModel.recorder != null) {
      return streamModel.recorder!.stopRecorder();
    }
    return null;
  }

  Future<void>? stopPlayer() {
    if (streamModel.player != null) {
      return streamModel.player!.stopPlayer();
    }
    return null;
  }

  Future<void> record() async {
    await streamModel.recorder!.startRecorder(
      codec: Codec.pcm16,
      toStream: streamModel
          .streamClient!.foodStreamController!.sink, // ***** THIS IS THE LOOP !!! *****
      sampleRate: 44000,
      numChannels: 1,
    );
    notifyListeners();
  }

  Future<void> stop() async {
    if (streamModel.recorder != null) {
      await streamModel.recorder!.stopRecorder();
    }
    if (streamModel.player != null) {
      //   await _player!.stopPlayer();
    }
    notifyListeners();
  }

  void getRecFn() {
    if (!streamModel.isInitiated) {
      return;
    }
    if (streamModel.recorder!.isRecording) {
      stop();
    } else {
      record();
    }
  }

  sendUpdate(BuildContext context){
    final StreamClient c = streamModel.streamClient!;
    c.sendUpdate(StreamMessage.update(
        channelData:  ChannelDataModel(
            channelname: Prefs().storedData.getString("channelName")!,
            category: Prefs().storedData.getString("category")!,
            channelid: Prefs().storedData.getString("uid")!
        ),
        channelType: "a"
    ));
  }
}
