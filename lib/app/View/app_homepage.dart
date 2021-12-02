import 'dart:async';
import 'dart:typed_data';

import 'package:cmt_projekt/server/streamclient.dart';
import 'package:cmt_projekt/viewmodel/stream_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:sound_stream/sound_stream.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({Key? key}) : super(key: key);

  @override
  _AppHomePageState createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: ElevatedButton(onPressed: () {
        Navigator.of(context)
            .pushNamed('/Demo');
        context.read<StreamViewModel>().startup();
      }, child: null,),
    );
  }
}
