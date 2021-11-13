import 'dart:convert';

import 'package:cmt_projekt/model/querymodel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class queryToDatabase {
  //Ansluter till server med ipadress och port
  var channel =
      WebSocketChannel.connect(Uri.parse('ws://188.150.156.238:5601'));
  queryToDatabase() {
    //ställer in så att ifall man får ett meddelande tillbaka skall funktionen
    //onMessage köras.
    channel.stream.listen((message) => onMessage(message));
  }
  void sendRequest(QueryModel message) {
    print(jsonEncode(message));
    channel.sink.add(jsonEncode(message));
  }

  void onMessage(message) {
    //Skriver ut meddelandet.
    print(message);
  }
}
