import 'dart:async';
import 'dart:convert';

import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/model/querymodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Låter applikationen hämta och skicka data till databasen.
class DatabaseApi {
  //En ström som skickar ut en bool till alla lyssnare.
  StreamController<bool> streamController = StreamController<bool>.broadcast();
  //Ansluter till server med ipadress och port
  var channel =
      WebSocketChannel.connect(Uri.parse('ws://localhost:5604'));
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
    if (message == "") {
      streamController.add(false);
    } else {
      await Prefs().storedData.setString(
          "uid", QueryModel.fromJsonUserinfo(jsonDecode(message)).uid);
      await Prefs().storedData.setString(
          "email", QueryModel.fromJsonUserinfo(jsonDecode(message)).email);
      streamController.add(true);
    }
  }
}
