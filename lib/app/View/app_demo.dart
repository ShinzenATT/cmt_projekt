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
    context.read<StreamViewModel>().startup();
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
                    onPressed: () {
                      context.read<StreamViewModel>().getRecFn;
                    },
                    //color: Colors.white,
                    //disabledColor: Colors.grey,
                    child: Text(context.watch<StreamViewModel>().smodel.recorder!.isRecording ? 'Stop' : 'Record'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(context.watch<StreamViewModel>().smodel.recorder!.isRecording
                      ? 'Playback to your headset!'
                      : 'Recorder is stopped'),
                ]),
              ),
            ],
          ),
        ));
  }
}