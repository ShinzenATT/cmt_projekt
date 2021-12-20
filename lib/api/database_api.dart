import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:cmt_projekt/model/query_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants.dart';

/// Låter applikationen hämta och skicka data till databasen.

class DatabaseApi {
  //En ström som skickar ut en bool till alla lyssnare.
  StreamController<QueryModel> streamController =
      StreamController<QueryModel>.broadcast();
  StreamController<List<QueryModel>> channelController =
      StreamController<List<QueryModel>>.broadcast();
  bool pollingBool = false;

  //Ansluter till server med ipadress och port
  late WebSocketChannel channel;

  DatabaseApi() {
    init();
    poller();
    //ställer in så att ifall man får ett meddelande tillbaka skall funktionen
    //onMessage köras.
  }
  void init() {
    channel = WebSocketChannel.connect(Uri.parse('ws://188.150.156.238:5604'));
    channel.stream.listen((message) => onMessage(message));
  }

  void poller() async {
    while (true) {
      pollingBool = false;
      await Future.delayed(const Duration(seconds: 5), () {
        try {
          channel.sink.add(jsonEncode(QueryModel.polling()));
        } catch (WebSocketChannelException) {}
        if (!pollingBool) {
          channel.sink.close();
          init();
        }
      });
    }
  }

  ///Skickar en QueryModel till servern
  void sendRequest(QueryModel message) {
    try {
      channel.sink.close();
      init();
      print(jsonEncode(message));
      channel.sink.add(jsonEncode(message));
    } catch (WebSocketChannelException) {}
  }

  ///Metod som hanterar inkommande meddelanden från servern.
  void onMessage(String message) async {
    if (message == "") {
      return;
    }
    String queryCode = (jsonDecode(message)['code'] as List)[0];
    if (queryCode == dbGetInfo) {
      streamController
          .add(QueryModel.fromJson((jsonDecode(message)['result'] as List)[0]));
    } else if (queryCode == dbGetOnlineChannels) {
      //channelController.add(jsonDecode(message)['result'] as List);

      ///Kolla här för tips om hur man kan konvertera alla json queries i listan till enskilda objekt.
      List<QueryModel> listOfChannels = [];
      for (int i = 0; i < (jsonDecode(message)['result'] as List).length; i++) {
        listOfChannels.add(
            (QueryModel.fromJson((jsonDecode(message)['result'] as List)[i])));
      }
      channelController.add(listOfChannels);
    } else if (queryCode == dbPing) {
      pollingBool = true;
    }
    //  channel.sink.close();
  }
}
