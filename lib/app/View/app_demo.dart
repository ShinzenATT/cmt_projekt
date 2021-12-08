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
import 'package:cmt_projekt/viewmodel/stream_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:provider/src/provider.dart';

class StreamLoop extends StatefulWidget {
  @override
  _StreamLoopState createState() => _StreamLoopState();
}

class _StreamLoopState extends State<StreamLoop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Column(
            children: [Text('COMMENT'), Text('Demo')],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Colors.black,
                  Colors.blueAccent,
                ])),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Colors.blueAccent,
          ],
        )),
        child: Column(
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
              child: Text(
                  context.watch<StreamViewModel>().smodel.recorder!.isRecording
                      ? 'Playback to your headset!'
                      : 'Recorder is stopped'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
            context.watch<StreamViewModel>().smodel.recorder!.isRecording
                ? Icons.mic
                : Icons.mic_off),
        onPressed: () {
          context.read<StreamViewModel>().getRecFn();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
