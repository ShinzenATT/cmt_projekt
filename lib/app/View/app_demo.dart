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
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/server/streamclient.dart';
import 'package:cmt_projekt/server/streamserver.dart';
import 'package:cmt_projekt/viewmodel/stream_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
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
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Column(
            children: const [
              Text('COMMENT'),
              Text('Demo'),
            ],
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  TextFormField(
                    controller: context.watch<StreamViewModel>().hostID,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      labelText: 'HostId',
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 50,
                  child: GradientElevatedButton(
                    child: const Text(
                      'Host',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(appChannel);
                    },
                    gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black,
                          Colors.blueAccent,
                        ]),
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: GradientElevatedButton(
                    child: const Text(
                      'Join',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(appChannel);
                    },
                    gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.black,
                          Colors.blueAccent,
                        ]),
                  ),
                ),
              ],
            ),
            /* Center(
              child: SizedBox(
                width: 200,
                height: 50,
                child: GradientElevatedButton(
                  child: const Text(
                    'DemoKanal',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(appChannel);
                    context.read<StreamViewModel>().startup();
                  },
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black,
                        Colors.blueAccent,
                      ]),
                ),
              ),
            ), */
          ],
        ),
      ),
    );
  }
}
