import 'dart:async';
import 'dart:convert';
import 'package:cmt_projekt/model/querymodel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants.dart';

/// Låter applikationen hämta och skicka data till databasen.

class DatabaseApi {

  //En ström som skickar ut en bool till alla lyssnare.
  StreamController<QueryModel> streamController =
  StreamController<QueryModel>.broadcast();
  StreamController<List<QueryModel>> channelController = StreamController<
      List<QueryModel>>.broadcast();

  //Ansluter till server med ipadress och port
  var channel =
  WebSocketChannel.connect(Uri.parse('ws://188.150.156.238:5604'));

  DatabaseApi() {
    //ställer in så att ifall man får ett meddelande tillbaka skall funktionen
    //onMessage köras.
    channel.stream.listen((message) => onMessage(message));
  }

  ///Skickar en QueryModel till servern
  void sendRequest(QueryModel message) {
    //print(jsonEncode(message));
    channel.sink.add(jsonEncode(message));
  }

  ///Metod som hanterar inkommande meddelanden från servern.
  void onMessage(String message) async {
    print(message);
    if (message == "") {
      return;
    }
    print((jsonDecode(message)['code'] as List)[0]);
    String QueryCode = (jsonDecode(message)['code'] as List)[0];
    if (QueryCode == dbGetInfo) {
      streamController
          .add(QueryModel.fromJson((jsonDecode(message)['result'] as List)[0]));
    } else if (QueryCode == dbGetOnlineChannels) {
      //channelController.add(jsonDecode(message)['result'] as List);

      ///Kolla här för tips om hur man kan konvertera alla json queries i listan till enskilda objekt.
      List<QueryModel> listOfChannels = [];
      for (int i = 0; i < (jsonDecode(message)['result'] as List).length; i++) {
        listOfChannels.add(
            (QueryModel.fromJson((jsonDecode(message)['result'] as List)[i])));
      }
      channelController.add(listOfChannels);
    }
  }
}
