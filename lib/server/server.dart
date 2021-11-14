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
    HttpServer server = await HttpServer.bind('192.168.0.37', 5601);
    //ställer in i att ifall man får ett meddelande ska onMessage köras.
    server.transform(WebSocketTransformer()).listen(onMessage);
  }

  void onMessage(var client) {
    client.listen((data) async {
      QueryModel query = QueryModel.fromJson(jsonDecode(data));
      if (query.isAccountCreation()) {
        String response =
            await db.createAccount(query.email, query.password, query.phone);
        print(response);
        client.add(response);
      } else {
        String response = await db.read(query.email, query.password);
        print(response);
        client.add(response);
      }
    });
  }
}
