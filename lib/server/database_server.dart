import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/model/query_model.dart';

import 'package:postgres/postgres.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() async {
  DatabaseServer();
}

/// Skapar en koppling mellan applikationen och databasen.
class DatabaseServer {
  DatabaseQueries db = DatabaseQueries();
  late HttpServer server;
  Map<WebSocketChannel, StreamController> connectedClients = {};

  DatabaseServer() {
    initServer();
  }

  void initServer() async {
    var handler = webSocketHandler((WebSocketChannel webSocket) {
      ///Sätter upp så att alla klienter som ansluter får en egen StreamController och läggs till i mapen connectedUsers.
      connectedClients[webSocket] = StreamController.broadcast();

      ///Sätter upp en listen funktion som skickar vidare all inkommande data från websocketen till StreamControllern.
      ///Ondone funktionen websocketens StreamController vilket i sin tur gör host/client stängningsmetoder.
      webSocket.stream.listen((event) {
        connectedClients[webSocket]!.sink.add(event);
      }, onDone: () {
        connectedClients[webSocket]!.close();
      });

      ///Sätter upp första listen funktionen till StreamControllern. Här kollas ifall den anslutna användaren är en host eller klient
      ///och sätter sedan upp rätt funktioner beroende på vad den är.
      connectedClients[webSocket]!.stream.asBroadcastStream().listen((data) {
        onMessage(webSocket, data);
      }, onDone: () {
        connectedClients.remove(webSocket);
      });
    });

    //Öppnar server på port och ip.
    shelf_io.serve(handler, '192.168.0.7', 5604).then((server) {
      print('Serving at ws://${server.address.host}:${server.port}');
    });
  }

  void onMessage(WebSocketChannel client, data) async {
    QueryModel query = QueryModel.fromJson(jsonDecode(data));
    if (query.code == dbPing) {
      Map mapOfQueries = {};
      mapOfQueries['code'] = [dbPing];
      client.sink.add(jsonEncode(mapOfQueries));
      return;
    }
    print(query.code);
    switch (query.code) {
      case dbAccount:
        {
          String response = await db.createAccount(
              query.email!, query.password!, query.phone!);
          client.sink.add(response);
        }
        break;
      case dbLogin:
        {
          String response =
              await db.compareCredentials(query.email!, query.password!);
          client.sink.add(response);
        }
        break;
      case dbCreateChannel:
        {
          db.createChannel(query.channelName!, query.uid!, query.category!);
          String response = await db.getOnlineChannels();
          for (WebSocketChannel client in connectedClients.keys) {
            print(client);
            client.sink.add(response);
          }
        }
        break;
      case dbChannelOffline:
        {
          db.goOffline(query.uid!);
          String response = await db.getOnlineChannels();
          client.sink.add(response);
          for (WebSocketChannel client in connectedClients.keys) {
            print(client);
            client.sink.add(response);
          }
        }
        break;
      case dbGetOnlineChannels:
        {
          String response = await db.getOnlineChannels();
          client.sink.add(response);
        }
        break;
      default:
        {
          break;
        }
    }
  }
}

/// Skapar queries och kommunicerar med databasen.
class DatabaseQueries {
  //Database host ip

  Future<String> compareCredentials(String login, String pass) async {
    try {
      var connection = PostgreSQLConnection("localhost", 5432, "cmt_projekt",
          username: "pi", password: "Kastalagatan22");
      await connection.open();

      List<List<dynamic>> results = await connection.query(
          "SELECT email, phone FROM Account WHERE ((email = '$login' OR phone = '$login') AND (password = '$pass'))");
      if (results.isEmpty) {
        return "";
      }
      return getInfo(login);
    } on PostgreSQLException {
      print("an error in compareCredentials");
      return "";
    }
  }

  Future<String> createAccount(String email, String pass, String phone) async {
    try {
      var connection = PostgreSQLConnection("localhost", 5432, "cmt_projekt",
          username: "pi", password: "Kastalagatan22");
      await connection.open();

      List<List<dynamic>> results = await connection
          .query("INSERT INTO Account VALUES('$email', '$pass', '$phone')");
      return (getInfo(email));
    } on PostgreSQLException {
      print("an error in createAccount");
      return ("");
    }
  }

  Future<String> getInfo(String login) async {
    try {
      var connection = PostgreSQLConnection("localhost", 5432, "cmt_projekt",
          username: "pi", password: "Kastalagatan22");
      await connection.open();

      List<List<dynamic>> results = await connection.query(
          "SELECT jsonb_build_object('email',email,'phone',phone,'uid',uid) FROM Account WHERE ((email = '$login' OR phone = '$login'))");

      if (results.isEmpty) {
        return "";
      }

      ///Då result är en List<List<dynamic>> så gör result.first[0] att man får den första List<dynamic>, dvs första raden.
      ///Efter det tar man ut varje element på raden för sig och kopplar det till rätt variabel.
      Map mapOfQueries = {};
      mapOfQueries['code'] = [dbGetInfo];
      mapOfQueries['result'] = [];
      List listOfChannels = mapOfQueries['result'];
      for (final row in results) {
        listOfChannels.add(row[0]);
      }
      print(jsonEncode(mapOfQueries));
      return jsonEncode(mapOfQueries);
    } on PostgreSQLException {
      print("error in createChannel");
      return "";
    }
  }

  void goOffline(String uid) async {
    try {
      var connection = PostgreSQLConnection("localhost", 5432, "cmt_projekt",
          username: "pi", password: "Kastalagatan22");
      await connection.open();
      await connection.query(
          "UPDATE Channel SET isonline = false WHERE channelid = '$uid'");
    } on PostgreSQLException {
      print("error in goOffline");
    }
  }

  void createChannel(String channelName, String uid, String category) async {
    try {
      var connection = PostgreSQLConnection("localhost", 5432, "cmt_projekt",
          username: "pi", password: "Kastalagatan22");
      await connection.open();

      List<List<dynamic>> results = await connection.query(
          "INSERT INTO channelview VALUES('$uid','$channelName','$category')");
    } on PostgreSQLException {
      print("error in createChannel");
    }
  }

  Future<String> getOnlineChannels() async {
    try {
      var connection = PostgreSQLConnection("localhost", 5432, "cmt_projekt",
          username: "pi", password: "Kastalagatan22");
      await connection.open();

      List<List<dynamic>> results = await connection.query(
          "SELECT jsonb_build_object('category',category, 'channelid',channelid,'channelname',channelname,'isonline',isonline) FROM Channel ");

      if (results.isEmpty) {
        return "";
      }

      ///Då result är en List<List<dynamic>> så gör result.first[0] att man får den första List<dynamic>, dvs första raden.
      ///Efter det tar man ut varje element på raden för sig och kopplar det till rätt variabel.
      Map mapOfQueries = {};
      mapOfQueries['code'] = [dbGetOnlineChannels];
      mapOfQueries['result'] = [];
      List listOfChannels = mapOfQueries['result'];
      for (final row in results) {
        listOfChannels.add(row[0]);
      }
      print(jsonEncode(mapOfQueries));
      return jsonEncode(mapOfQueries);
    } catch (PostgreSQLException) {
      print("error in createChannel");
      print(PostgreSQLException);
      return "";
    }
  }
}
