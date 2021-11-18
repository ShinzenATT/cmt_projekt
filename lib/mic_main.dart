

/*
 * Copyright 2018, 2019, 2020, 2021 Dooboolab.
 *
 * This file is part of Flutter-Sound.
 *
 * Flutter-Sound is free software: you can redistribute it and/or modify
 * it under the terms of the Mozilla Public License version 2 (MPL2.0),
 * as published by the Mozilla organization.
 *
 * Flutter-Sound is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * MPL General Public License for more details.
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */



import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cmt_projekt/server/streamclient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:flutter_sound_lite/public/tau.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/*
 * This is an example showing how to record to a Dart Stream.
 * It writes all the recorded data from a Stream to a File, which is completely stupid:
 * if an App wants to record something to a File, it must not use Streams.
 *
 * The real interest of recording to a Stream is for example to feed a
 * Speech-to-Text engine, or for processing the Live data in Dart in real time.
 *
 */

void main() {
  runApp(RecordToStreamExample());
}

///
const int tSampleRate = 44000;
typedef _Fn = void Function();

/// Example app.
class RecordToStreamExample extends StatefulWidget {
  @override
  _RecordToStreamExampleState createState() => _RecordToStreamExampleState();
}

class _RecordToStreamExampleState extends State<RecordToStreamExample> {
  Client c = Client();

  FlutterSoundPlayer? _player = FlutterSoundPlayer();
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  bool _playerIsInited = false;
  bool _recorderIsInited = false;
  bool _playbackReady = false;
  String? _mPath;
  StreamSubscription? _recordingDataSubscription;

  Future<void> _openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }
    await _recorder!.openAudioSession();
    setState(() {
      _recorderIsInited = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    _player!.openAudioSession().then((value) {
      setState(() {
        _playerIsInited = true;
      });
    });
    _openRecorder();
  }

  @override
  void dispose() {
    stopPlayer();
    _player!.closeAudioSession();
    _player = null;

    stopRecorder();
    _recorder!.closeAudioSession();
    _recorder = null;
    super.dispose();
  }

  Future<IOSink> createFile() async {
    var tempDir = await getTemporaryDirectory();
    _mPath = '${tempDir.path}/flutter_sound_example.pcm';
    var outputFile = File(_mPath!);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    return outputFile.openWrite();
  }

  // ----------------------  Here is the code to record to a Stream ------------

  Future<void> record() async {
    assert(_recorderIsInited && _player!.isStopped);
    var sink = await createFile();
    var recordingDataController = StreamController<Food>();
    _recordingDataSubscription =
        recordingDataController.stream.listen((buffer) {
          if (buffer is FoodData) {
            c.sendData(buffer);
          }
        });
    await _recorder!.startRecorder(
      toStream: recordingDataController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: tSampleRate,
    );
    setState(() {});
  }
  // --------------------- (it was very simple, wasn't it ?) -------------------

  Future<void> stopRecorder() async {
    await _recorder!.stopRecorder();
    if (_recordingDataSubscription != null) {
      await _recordingDataSubscription!.cancel();
      _recordingDataSubscription = null;
    }
    _playbackReady = true;
  }

  _Fn? getRecorderFn() {
    if (!_recorderIsInited || !_player!.isStopped) {
      return null;
    }
    return _recorder!.isStopped
        ? record
        : () {
      stopRecorder().then((value) => setState(() {}));
    };
  }

  void play() async {
    assert(_playerIsInited &&
        _playbackReady &&
        _recorder!.isStopped &&
        _player!.isStopped);
    await _player!.startPlayerFromStream(
        sampleRate: tSampleRate,
        codec: Codec.pcm16,
        numChannels: 1,
    );
    setState(() {});
  }

  Future<void> stopPlayer() async {
    await _player!.stopPlayer();
  }

  _Fn? getPlaybackFn() {
    if (!_playerIsInited || !_playbackReady || !_recorder!.isStopped) {
      return null;
    }
    return _player!.isStopped
        ? play
        : () {
      stopPlayer().then((value) => setState(() {}));
    };
  }

  // ----------------------------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(

          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.all(3),
                height: 80,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFFAF0E6),
                  border: Border.all(
                    color: Colors.indigo,
                    width: 3,
                  ),
                ),
                child: Row(children: [
                  ElevatedButton(
                    onPressed: getRecorderFn(),
                    //color: Colors.white,
                    //disabledColor: Colors.grey,
                    child: Text(_recorder!.isRecording ? 'Stop' : 'Record'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(_recorder!.isRecording
                      ? 'Recording in progress'
                      : 'Recorder is stopped'),
                ]),
              ),
              Container(
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.all(3),
                height: 80,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFFAF0E6),
                  border: Border.all(
                    color: Colors.indigo,
                    width: 3,
                  ),
                ),
                child: Row(children: [
                  ElevatedButton(
                    onPressed: getPlaybackFn(),
                    //color: Colors.white,
                    //disabledColor: Colors.grey,
                    child: Text(_player!.isPlaying ? 'Stop' : 'Play'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(_player!.isPlaying
                      ? 'Playback in progress'
                      : 'Player is stopped'),
                ]),
              ),
            ],
          ),
        ),
      );
    }
  }