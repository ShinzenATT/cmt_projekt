import 'dart:convert';
import 'dart:io';

import 'package:cmt_projekt/model/querymodel.dart';
import 'package:cmt_projekt/server/database.dart';

void main() async {
  Server();
}

//Skickar tillbaka meddelandet till klienten som skickade meddelandet från början

class Server {
  Database db = Database();
  late HttpServer server;

  Server() {
    initServer();
  }

  void initServer() async {
    //Öppnar server på port och ip.
    HttpServer server = await HttpServer.bind('188.150.156.238', 5601);
    //ställer in i att ifall man får ett meddelande ska onMessage köras.
    server.transform(WebSocketTransformer()).listen(onMessage);
  }

  void onMessage(var client) {
    client.listen((data) {
      QueryModel query = QueryModel.fromJson(jsonDecode(data));
      if (query.isAccountCreation()) {
        db.createAccount(query.email, query.password, query.phone);
      } else if (query.email.isEmpty) {
        db.read(query.phone, query.password);
      } else {
        db.read(query.email, query.password);
      }
    });
  }
}
