import 'dart:async';
import 'dart:convert';

import 'package:cmt_projekt/model/querymodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Låter applikationen hämta och skicka data till databasen.
class DatabaseApi {
  //En ström som skickar ut en bool till alla lyssnare.
  StreamController<bool> streamController = StreamController<bool>.broadcast();
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
    print(jsonEncode(message));
    channel.sink.add(jsonEncode(message));
  }

  ///Metod som hanterar inkommande meddelanden från servern.
  void onMessage(String message) async {
    //Skriver ut meddelandet.
    print(message);
    if (message == "true") {
      streamController.add(true);
    } else if (message == 'false') {
      streamController.add(false);
    }else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', QueryModel.fromJsonLogin(jsonDecode(message)).uid);
      await prefs.setString('email', QueryModel.fromJsonLogin(jsonDecode(message)).email);
      print(prefs.getString("uid"));
    }
  }
}
