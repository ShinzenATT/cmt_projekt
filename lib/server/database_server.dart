import 'dart:convert';
import 'dart:io';

import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/model/querymodel.dart';

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
    var connection = PostgreSQLConnection("localhost", 5432, "cmt_projekt",
        username: "pi", password: "Kastalagatan22");
    await connection.open();

    List<List<dynamic>> results = await connection.query(
        "SELECT email, phone FROM Account WHERE ((email = '$login' OR phone = '$login') AND (password = '$pass'))");
    if (results.isEmpty) {
      return "";
    }
    return getInfo(login);
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
      return ("");
    }
  }

  Future<String> getInfo(String login) async {
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
    String message =
        '{"uid": "${results.first[0].values.elementAt(0)}", "email": "${results.first[0].values.elementAt(1)}", "phone": "${results.first[0].values.elementAt(2)}"}';
    return message;
  }

  void goOffline(String uid) async {
    try {
      var connection = PostgreSQLConnection("localhost", 5432, "cmt_projekt",
          username: "pi", password: "Kastalagatan22");
      await connection.open();
      await connection.query(
          "UPDATE Channel SET isonline = false WHERE channelid = '$uid'");
    } on PostgreSQLException {
      print(PostgreSQLException);
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
      print(PostgreSQLException);
    }
  }
}
