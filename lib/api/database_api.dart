import 'dart:core';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cmt_projekt/model/query_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../app/View/app_createaccountpage.dart';
import '../constants.dart';
import '../environment.dart';
import '../viewmodel/vm.dart';


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
          log('Connection to server lost');
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
      log('Connection to server lost');
    }
  }

  ///Method that handles all incoming messages from the database server.
  void onMessage(String message) async {
    if (message == "") {
      return;
    }
    //userErrorMessage(message);
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
   ///Does not work!
  ///Method that sends a error message back to the user.
  void userErrorMessage(String message) async {
    print("void userErrorMessage");
    //NaviHandler _navi = NaviHandler._internal();
    // var retContext = navi_.NaviHandler();
    //context: navigatorKey.currentContext!;
    var retContext = navigatorKey.currentState!.context;
    await showErrorDialog(
      //retContext,
      retContext,
        //navigatorKey.currentState!.context,
    "Misslyckades med att skapa ett konto"
    );
  }

}

