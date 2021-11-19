import 'dart:async';
import 'dart:convert';

import 'package:cmt_projekt/model/querymodel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class queryToDatabase {
  //En ström som skickar ut en bool till alla lyssnare.
  StreamController<bool> streamController = StreamController<bool>.broadcast();
  //Ansluter till server med ipadress och port
  var channel =
      WebSocketChannel.connect(Uri.parse('ws://188.150.156.238:5604'));
  queryToDatabase() {
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
  void onMessage(String message) {
    //Skriver ut meddelandet.
    print(message);
    if (message == "true") {
      streamController.add(true);
    } else {
      streamController.add(false);
    }
  }
}
