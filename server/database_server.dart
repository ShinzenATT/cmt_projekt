import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cmt_projekt/model/query_model.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'package:postgres/postgres.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dbcrypt/dbcrypt.dart';

import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/environment.dart';

void main() async {
  DatabaseServer();
}

/// Creates a connection between the database and the application.
class DatabaseServer {
  DatabaseQueries db = DatabaseQueries();
  late HttpServer server;
  Map<WebSocketChannel, StreamController> connectedClients = {};

  DatabaseServer() {
    initServer();
  }

  void initServer() async {
    var handler = webSocketHandler((WebSocketChannel webSocket) {
      ///Gives all clients that connects their own StreamController and adds them to the map connectedUsers.
      connectedClients[webSocket] = StreamController.broadcast();

      ///Sets up a listen function that forwards all incoming data from the web socket to the StreamController.
      ///The onDone function is called when the web socket connection is closed and handles the host/clients close methods.
      webSocket.stream.listen((event) {
        connectedClients[webSocket]!.sink.add(event);
      }, onDone: () {
        connectedClients[webSocket]!.close();
      });

      ///Sets up the first listen function for the StreamController. Here it checks whether the web socket is a host or client and acts accordingly.
      connectedClients[webSocket]!.stream.asBroadcastStream().listen((data) {
        onMessage(webSocket, data);
      }, onDone: () {
        connectedClients.remove(webSocket);
      });
    });

    shelf_io.serve(handler, localServer, 5604).then((server) {
      logger.i('Database server serving at ws://${server.address.host}:${server.port}');
    });
  }

  ///This function is called for each message sent to the database and interpretate its intention.
  void onMessage(WebSocketChannel client, data) async {
    QueryModel query = QueryModel.fromJson(jsonDecode(data));
    if (query.code == dbPing) {
      Map mapOfQueries = {};
      mapOfQueries['code'] = [dbPing];
      client.sink.add(jsonEncode(mapOfQueries));
      return;
    }

    switch (query.code) {
      case dbAccount:
        {
          String response = await db.createAccount(
              query.email!, query.password!, query.phone!, query.username!);
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
          await db.createChannel(query.channelName!, query.uid!, query.category!);
          String response = await db.getOnlineChannels();
          for (WebSocketChannel client in connectedClients.keys) {
            client.sink.add(response);
          }
        }
        break;
      case dbChannelOffline:
        {
          await db.goOffline(query.uid!);
          String response = await db.getOnlineChannels();
          for (WebSocketChannel client in connectedClients.keys) {
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
      case dbAddViewers:
        {
          await db.insertViewer(query.uid!, query.channelid!);
          String response = await db.getOnlineChannels();
          for (WebSocketChannel client in connectedClients.keys) {
            logger.d(client);
            client.sink.add(response);
          }

        }
        break;
      case dbDelViewers:
        {
          await db.delViewers(query.channelid!);
          String response = await db.getOnlineChannels();
          for (WebSocketChannel client in connectedClients.keys) {
            logger.d(client);
            client.sink.add(response);
          }
        }
        break;
      case dbDelViewer:
        {
          await db.delViewer(query.uid!, query.channelid!);
          String response = await db.getOnlineChannels();
          for (WebSocketChannel client in connectedClients.keys) {
            logger.d(client);
            client.sink.add(response);
          }
        }
        break;

      default:
        {
          break;
        }
    }
  }
}

/// Creates queries and communicates with the database.
class DatabaseQueries {
  //Database host ip
  var connection = PostgreSQLConnection(dbConnection, dbPort, dbDatabase,
      username: dbUser, password: dbPassword);
  DatabaseQueries() {
    init();
  }

  void init() async {
    await connection.open();
  }

  Future<String> compareCredentials(String login, String pass) async {
    try {
      List<List<dynamic>> results = await connection.query(
          "SELECT password FROM Account WHERE (email = '$login' OR phone = '$login')");
      if (results.length == 1 && DBCrypt().checkpw(pass, results[0][0])) {
        return getInfo(login);
      }
      return "";
    } on PostgreSQLException catch (e) {
      logger.e("an error in compareCredentials \n" + (e.message ?? ""), [e, e.stackTrace]);
      return "";
    }
  }

  Future<String> createAccount(String email, String pass, String phone, String username) async {
    try {
      await connection
          .query("INSERT INTO Account VALUES('$email', '$pass', '$phone', '$username')");
      return (getInfo(email));
    } on PostgreSQLException catch (e) {
      logger.e("an error in createAccount\n" + (e.message ?? ""), [e, e.stackTrace]);
      return "";
    }
  }

  Future<String> getInfo(String login) async {
    try {
      List<List<dynamic>> results = await connection.query(
          "SELECT jsonb_build_object('email',email,'phone',phone,'uid',uid,'username',username) FROM Account WHERE ((email = '$login' OR phone = '$login'))");

      if (results.isEmpty) {
        return "";
      }

      ///The result is a List<List><dynamic>> which means that result.first[0] gives the first List<dynamic> which is the first row.
      ///After which each element in the row is compared to the right variable.
      Map mapOfQueries = {};
      mapOfQueries['code'] = [dbGetInfo];
      mapOfQueries['result'] = [];
      List listOfChannels = mapOfQueries['result'];
      for (final row in results) {
        listOfChannels.add(row[0]);
      }
      logger.d(jsonEncode(mapOfQueries));
      return jsonEncode(mapOfQueries);
    } on PostgreSQLException catch (e) {
      logger.e("error in getInfo\n" + (e.message ?? ""), [e, e.stackTrace]);
      return "";
    }
  }

  Future<void> goOffline(String uid) async {
    try {
      await connection.query(
          "UPDATE Channel SET isonline = false WHERE channelid = '$uid'");
    } on PostgreSQLException catch (e) {
      logger.e("error in goOffline\n" + (e.message ?? ""), [e, e.stackTrace]);
    }
  }

  Future<void> createChannel(String channelName, String uid, String category) async {
    try {
      await connection.query(
          "INSERT INTO channelview VALUES('$uid','$channelName','$category')");
    } on PostgreSQLException catch (e) {
      logger.e("error in createChannel\n" + (e.message ?? ""), [e, e.stackTrace]);
    }
  }

  Future<String> getOnlineChannels() async {
    try {
      List<List<dynamic>> results = await connection.query(
          "SELECT jsonb_build_object('category',category, 'channelid',channelid,'channelName',channelname,'isonline',isonline,'username',username, 'total',(SELECT COUNT(jsonb_build_object('viewer',viewer)) as total FROM Viewers WHERE channel = channelid)) FROM Channel, Account WHERE uid = channelid ");

      /*
      if (results.isEmpty) {
        return "";
      }
       */

      ///The result is a List<List><dynamic>> which means that result.first[0] gives the first List<dynamic> which is the first row.
      ///After which each element in the row is compared to the right variable.
      Map mapOfQueries = {};
      mapOfQueries['code'] = [dbGetOnlineChannels];
      mapOfQueries['result'] = [];
      List listOfChannels = mapOfQueries['result'];
      for (final row in results) {
        listOfChannels.add(row[0]);
      }
      logger.d(jsonEncode(mapOfQueries));
      return jsonEncode(mapOfQueries);
    } on PostgreSQLException catch (e) {
      logger.e("error in getOnlineChannels\n" + (e.message ?? ""), [e, e.stackTrace]);
      return "";
    }
  }

  Future<void> insertViewer(String uid, String channelId) async{
    try {
      await connection.query(
          "INSERT INTO Viewers VALUES('$uid','$channelId')");
    } on PostgreSQLException catch (e) {
      logger.e("error in insertViewer\n" + (e.message ?? ""), [e, e.stackTrace]);
    }
  }

  Future<void> delViewer(String uid, String channelId) async{

    try {
      await connection.query(
          "DELETE FROM Viewers WHERE(viewer = '$uid' AND channel = '$channelId')");
    } on PostgreSQLException catch (e) {
      logger.e("error in delViewer\n" + (e.message ?? ""), [e, e.stackTrace]);
    }
  }

  Future<void> delViewers(String channelId) async{
    try {
      await connection.query(
          "DELETE FROM Viewers WHERE(channel = '$channelId')");
    } on PostgreSQLException catch (e) {
      logger.e("error in delViewers\n" + (e.message ?? ""), [e, e.stackTrace]);
    }
  }

}
