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
import 'dart:typed_data';
import 'package:cmt_projekt/server/streamclient.dart';
import 'package:cmt_projekt/server/streamserver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';

/*
 *
 * ```streamLoop()``` is a very simple example which connect the FlutterSoundRecorder sink
 * to the FlutterSoundPlayer Stream.
 * Of course, we do not play to the loudspeaker to avoid a very unpleasant Larsen effect.
 * This example does not use a new StreamController, but use directly `foodStreamController`
 * from flutter_sound_player.dart.
 *
 */

void main() {
  runApp(StreamLoop());
}

const int _sampleRateRecorder = 44000;
const int _sampleRatePlayer = 44000; // same speed than the recorder

///
typedef Fn = void Function();

/// Example app.
class StreamLoop extends StatefulWidget {
  @override
  _StreamLoopState createState() => _StreamLoopState();
}

class _StreamLoopState extends State<StreamLoop> {
  FlutterSoundPlayer? _player = FlutterSoundPlayer();
  FlutterSoundRecorder? _recorder = FlutterSoundRecorder();
  late Uint8List buffer;

  bool _isInited = false;

  late Client c = Client(_player);


  Future<void> init() async {
    await _recorder!.openAudioSession(
      device: AudioDevice.blueToothA2DP,
      audioFlags: allowHeadset | allowEarPiece | allowBlueToothA2DP,
      category: SessionCategory.playAndRecord,
    );
    await _player!.openAudioSession(
      device: AudioDevice.blueToothA2DP,
      audioFlags: allowHeadset | allowEarPiece | allowBlueToothA2DP,
      category: SessionCategory.playAndRecord,
    );
  }

  @override
  void initState() {
    super.initState();
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    init().then((value) {
      setState(() {
        _isInited = true;
      });
      c.listen();
    });
  }

  Future<void> release() async {
    await stopPlayer();
    await _player!.closeAudioSession();
    _player = null;

    await stopRecorder();
    await _recorder!.closeAudioSession();
    _recorder = null;
  }

  @override
  void dispose() {
    release();
    super.dispose();
  }

  Future<void>? stopRecorder() {
    if (_recorder != null) {
      return _recorder!.stopRecorder();
    }
    return null;
  }

  Future<void>? stopPlayer() {
    if (_player != null) {
      return _player!.stopPlayer();
    }
    return null;
  }

  Future<void> addStream() async {
    Stream<Food> stream;
  }

  Future<void> record() async {


    await _player!.startPlayerFromStream(
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: _sampleRatePlayer,
    );

    await _recorder!.startRecorder(
      codec: Codec.pcm16,
      toStream: c.foodStreamController!.sink, // ***** THIS IS THE LOOP !!! *****
      sampleRate: _sampleRateRecorder,
      numChannels: 1,
    );
    setState(() {});
  }

  Future<void> stop() async {
    if (_recorder != null) {
      await _recorder!.stopRecorder();
    }
    if (_player != null) {
   //   await _player!.stopPlayer();
    }
    setState(() {});
  }

  Fn? getRecFn() {
    if (!_isInited) {
      return null;
    }
    return _recorder!.isRecording ? stop : record;
  }

  // ----------------------------------------------------------------------------------------------------------------------

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
              onPressed: getRecFn(),
              //color: Colors.white,
              //disabledColor: Colors.grey,
              child: Text(_recorder!.isRecording ? 'Stop' : 'Record'),
            ),
            SizedBox(
              width: 20,
            ),
            Text(_recorder!.isRecording
                ? 'Playback to your headset!'
                : 'Recorder is stopped'),
          ]),
        ),
        ],
        ),
      ));
    }
  }