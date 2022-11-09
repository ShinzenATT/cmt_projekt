import 'dart:core';
import 'dart:async';
import 'dart:convert';

import 'package:cmt_projekt/model/query_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants.dart';


/// Api for fetching and sending data from the database.
class DatabaseApi {
  static final DatabaseApi _databaseApi = DatabaseApi._internal();
  StreamController<QueryModel> streamController =
  StreamController<QueryModel>.broadcast();
  StreamController<List<QueryModel>> channelController =
  StreamController<List<QueryModel>>.broadcast();
  bool pollingBool = false;

  //Connects to the server with ip address and port.
  late WebSocketChannel channel;

  factory DatabaseApi() {
    return _databaseApi;
  }
  DatabaseApi._internal() {
    init();
    poller();
  }

  void init() {
    channel = WebSocketChannel.connect(Uri.parse('ws://' + localServer + ':5604'));
    channel.stream.listen((message) => onMessage(message));
  }

  void poller() async {
    while (true) {
      pollingBool = false;
      await Future.delayed(const Duration(seconds: 7), () {
        try {
          channel.sink.add(jsonEncode(QueryModel.polling()));
        } on WebSocketChannelException {
          debugPrint('Connection to server lost');
        }
        if (!pollingBool) {
          channel.sink.close();
          init();
          sendRequest(QueryModel.getChannels());
        }
      });
    }
  }

  ///Sends a QueryModel in the form of jason to the databse server.
  void sendRequest(QueryModel message) {
    try {
      channel.sink.add(jsonEncode(message));
    } on WebSocketChannelException {
      debugPrint('Connection to server lost');
    }
  }

  ///Method that handles all incoming messages from the database server.
  void onMessage(String message) async {
    if (message == "") {
      return;
    }
    String queryCode = (jsonDecode(message)['code'] as List)[0];
    if (queryCode == dbGetInfo) {
      streamController
          .add(QueryModel.fromJson((jsonDecode(message)['result'] as List)[0]));
    } else if (queryCode == dbGetOnlineChannels) {
      List<QueryModel> listOfChannels = [];
      for (int i = 0; i < (jsonDecode(message)['result'] as List).length; i++) {
        listOfChannels.add(
            (QueryModel.fromJson((jsonDecode(message)['result'] as List)[i])));
      }
      channelController.add(listOfChannels);
    } else if (queryCode == dbPing) {
      pollingBool = true;
    }
  }
}
