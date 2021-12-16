import 'dart:convert';
import 'dart:io';

import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/model/query_model.dart';

import 'package:postgres/postgres.dart';

void main() async {
  DatabaseServer();
}

/// Skapar en koppling mellan applikationen och databasen.
class DatabaseServer {
  DatabaseQueries db = DatabaseQueries();
  late HttpServer server;

  DatabaseServer() {
    initServer();
  }

  void initServer() async {
    //Öppnar server på port och ip.
    HttpServer server = await HttpServer.bind('192.168.0.7', 5604);
    //ställer in i att ifall man får ett meddelande ska onMessage köras.
    server.transform(WebSocketTransformer()).listen(onMessage);
  }

  void onMessage(var client) {
    client.listen((data) async {
      print(jsonDecode(data));
      QueryModel query = QueryModel.fromJson(jsonDecode(data));
      print(query.code);
      switch (query.code) {
        case dbAccount:
          {
            String response = await db.createAccount(
                query.email!, query.password!, query.phone!);
            client.add(response);
          }
          break;
        case dbLogin:
          {
            String response =
                await db.compareCredentials(query.email!, query.password!);
            client.add(response);
          }
          break;
        case dbCreateChannel:
          {
            db.createChannel(query.channelName!, query.uid!, query.category!);
          }
          break;
        case dbChannelOffline:
          {
            db.goOffline(query.uid!);
          }
          break;
        case dbGetOnlineChannels:
          {
            String response = await db.getOnlineChannels();
            client.add(response);
          }
          break;
        default:
          {
            break;
          }
      }
    });
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
