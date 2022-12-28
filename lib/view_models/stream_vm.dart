import 'package:cmt_projekt/models/channel_data_model.dart';
import 'package:cmt_projekt/models/stream_model.dart';
import 'package:cmt_projekt/apis/stream_client.dart';
import 'package:cmt_projekt/models/streammessage_model.dart';
import 'package:cmt_projekt/widgets/go_live_settings_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';

/// A type alias of a function with no return type and parameters
typedef Fn = void Function();

/// A view model for handling stream based actions such as recording and listening to a stream
class StreamVM with ChangeNotifier {
  /// Contains the player/recorder and websocket, see [StreamModel]
  StreamModel streamModel = StreamModel();

  /// initiates stream, sound recorder and player in the [StreamModel]
  void startup(BuildContext context, ChannelDataModel? channel) {
    streamModel.player = FlutterSoundPlayer();
    streamModel.recorder = FlutterSoundRecorder();
    streamModel.streamClient = StreamClient(player: streamModel.player, channel: channel);
    init().then((value) {
      streamModel.isInitiated = true;
      streamModel.streamClient!.listen(context);
    });
  }

  /// stops the player/recorder and closes the connection to stream server
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

  /// configures various settings for the recorder and player
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

  /// stops the recorder/player and sets them to null
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

  /// stops the audio recorder if it's not null
  Future<String?> stopRecorder() async {
    if (streamModel.recorder != null) {
      return await streamModel.recorder!.stopRecorder();
    }
    return null;
  }

  /// stops the audio player if it's not null
  Future<void>? stopPlayer(){
    if (streamModel.player != null) {
      return streamModel.player!.stopPlayer();
    }
    return null;
  }

  /// starts the audio recorder and sends the audio stream to [StreamClient.foodStreamController] in [StreamModel]
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

  /// stops the audio recorder if it's not null
  Future<void> stop() async {
    if (streamModel.recorder != null) {
      await streamModel.recorder!.stopRecorder();
    }
    /*
    if (streamModel.player != null) {
         await _player!.stopPlayer();
    }
    */
    notifyListeners();
  }

  /// toggles the recording state of the audio recorder where it alternates with
  /// stopping the recorder and starting it again
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

  /// sends a update message with updated channel info from the channel argument,
  /// is usually gathered from the [GoLiveSettings] dialog for instance.
  sendUpdate(BuildContext context, ChannelDataModel channel){
    final StreamClient c = streamModel.streamClient!;
    c.sendUpdate(StreamMessage.update(
        channelData:  channel,
        channelType: "a"
    ));
  }
}
