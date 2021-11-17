import 'dart:async';
import 'dart:typed_data';
import 'package:cmt_projekt/server/streamclient.dart';
import 'package:flutter/material.dart';

import 'package:sound_stream/sound_stream.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RecorderStream _recorder = RecorderStream();
  PlayerStream _player = PlayerStream();

  Client c = Client();


  List<Uint8List> _micChunks = [];
  bool _isRecording = false;
  bool _isPlaying = false;

  late StreamSubscription _recorderStatus;
  late StreamSubscription _playerStatus;
  late StreamSubscription _audioStream;

  @override
  void initState() {
    super.initState();
    c.listen();
    initPlugin();
  }

  @override
  void dispose() {
    _recorderStatus.cancel();
    _playerStatus.cancel();
    _audioStream.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    _audioStream = _recorder.audioStream.listen((data) {
      if (_isPlaying) {
        _player.writeChunk(data);
      } else {
        _micChunks.add(data);
      }
      c.sendData(data);
    });

    _playerStatus = _player.status.listen((status) {
      if (mounted)
        setState(() {
          _isPlaying = status == SoundStreamStatus.Playing;
        });
    });

    await Future.wait([
      _recorder.initialize(),
      _player.initialize(),
    ]);
  }

  void _play() async {
    await _player.start();

    if (_micChunks.isNotEmpty) {
      for (var chunk in _micChunks) {
        await _player.writeChunk(chunk);
      }
      _micChunks.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              iconSize: 96.0,
              icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
              onPressed: _isRecording ? _recorder.stop : _recorder.start,
            ),
            IconButton(
              iconSize: 96.0,
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: _isPlaying ? _player.stop : _play,
            ),
          ],
        ),
      ),
    );
  }
}