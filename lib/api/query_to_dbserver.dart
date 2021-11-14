import 'dart:async';
import 'dart:convert';

import 'package:cmt_projekt/model/querymodel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class queryToDatabase {
  //Ansluter till server med ipadress och port
  final StreamController<bool> _createAccountController =
      StreamController<bool>();
  late Stream createAccountStreamValue;
  final StreamController<bool> _loginController = StreamController<bool>();
  late Stream loginStreamValue;
  var channel =
      WebSocketChannel.connect(Uri.parse('ws://188.150.156.238:5601'));
  queryToDatabase() {
    createAccountStreamValue = _createAccountController.stream;
    loginStreamValue = _loginController.stream;
    //ställer in så att ifall man får ett meddelande tillbaka skall funktionen
    //onMessage köras.
    channel.stream.listen((message) => onMessage(message));
  }
  void sendRequest(QueryModel message) {
    print(jsonEncode(message));
    channel.sink.add(jsonEncode(message));
  }

  void onMessage(String message) {
    //Skriver ut meddelandet.
    print(message);
    if (message == "true") {
      _createAccountController.add(true);
      _loginController.add(true);
    } else {
      _createAccountController.add(false);
      _loginController.add(false);
    }
  }

  Future<bool> waitformessage() async {
    await for (var fileInfo in channel.stream) {
      print(fileInfo);
    }
    return true;
  }
}
