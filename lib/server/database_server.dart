import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cmt_projekt/model/query_model.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'package:postgres/postgres.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants.dart';

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

      ///Sets up a listen function that forwards all incoming data from the websocket to the StreamController.
      ///The onDone function is called when the websocket connection is closed and handles the host/clients close methods.
      webSocket.stream.listen((event) {
        connectedClients[webSocket]!.sink.add(event);
      }, onDone: () {
        connectedClients[webSocket]!.close();
      });

      ///Sets up the first listen function for the StreamController. Here it checks whether the websocket is a host or client
      ///and acts accordingly.
      connectedClients[webSocket]!.stream.asBroadcastStream().listen((data) {
        onMessage(webSocket, data);
      }, onDone: () {
        connectedClients.remove(webSocket);
      });
    });

    shelf_io.serve(handler, dbConnection, 5604).then((server) {
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
            print(client);
            client.sink.add(response);
          }

        }
        break;
      case dbDelViewers:
        {
          await db.delViewers(query.channelid!);
          String response = await db.getOnlineChannels();
          for (WebSocketChannel client in connectedClients.keys) {
            print(client);
            client.sink.add(response);
          }
        }
        break;
      case dbDelViewer:
        {
          await db.delViewer(query.uid!, query.channelid!);
          String response = await db.getOnlineChannels();
          for (WebSocketChannel client in connectedClients.keys) {
            print(client);
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
  var connection = PostgreSQLConnection("localhost", 5432, "cmt_projekt",
      username: "pi", password: "Kastalagatan22");
  DatabaseQueries() {
    init();
  }

  void init() async {
    await connection.open();
  }

  Future<String> compareCredentials(String login, String pass) async {
    try {
      List<List<dynamic>> results = await connection.query(
          "SELECT email, phone FROM Account WHERE ((email = '$login' OR phone = '$login') AND (password = '$pass'))");
      if (results.isEmpty) {
        return "";
      }
      return getInfo(login);
    } catch (PostgreSQLException) {
      print("an error in compareCredentials");
      print(PostgreSQLException);
      return "";
    }
  }

  Future<String> createAccount(String email, String pass, String phone) async {
    try {
      List<List<dynamic>> results = await connection
          .query("INSERT INTO Account VALUES('$email', '$pass', '$phone')");
      return (getInfo(email));
    } catch (PostgreSQLException) {
      print("an error in createAccount");
      print(PostgreSQLException);
      return ("");
    }
  }

  Future<String> getInfo(String login) async {
    try {
      List<List<dynamic>> results = await connection.query(
          "SELECT jsonb_build_object('email',email,'phone',phone,'uid',uid,'username',username) FROM Account WHERE ((email = '$login' OR phone = '$login'))");

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
    } catch (PostgreSQLException) {
      print("error in getInfo");
      print(PostgreSQLException);
      return "";
    }
  }

  Future<void> goOffline(String uid) async {
    try {
      await connection.query(
          "UPDATE Channel SET isonline = false WHERE channelid = '$uid'");
    } catch (PostgreSQLException) {
      print("error in goOffline");
      print(PostgreSQLException);
    }
  }

  Future<void> createChannel(String channelName, String uid, String category) async {
    try {
      List<List<dynamic>> results = await connection.query(
          "INSERT INTO channelview VALUES('$uid','$channelName','$category')");
    } catch (PostgreSQLException) {
      print("error in createChannel");
      print(PostgreSQLException);
    }
  }

  Future<String> getOnlineChannels() async {
    try {
      List<List<dynamic>> results = await connection.query(
          "SELECT jsonb_build_object('category',category, 'channelid',channelid,'channelName',channelname,'isonline',isonline,'username',username, 'total',(SELECT COUNT(jsonb_build_object('viewer',viewer)) as total FROM Viewers WHERE channel = channelid)) FROM Channel, Account WHERE uid = channelid ");

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
      print("error in getOnlineChannels");
      print(PostgreSQLException);
      return "";
    }
  }

  Future<void> insertViewer(String uid, String channelId) async{
    try {
      await connection.query(
          "INSERT INTO Viewers VALUES('$uid','$channelId')");
    } catch (PostgreSQLException) {
      print("error in insertViewer");
    }
  }

  Future<void> delViewer(String uid, String channelId) async{

    try {
      await connection.query(
          "DELETE FROM Viewers WHERE(viewer = '$uid' AND channel = '$channelId')");
    } catch (PostgreSQLException) {
      print("error in delViewer");
    }
  }

  Future<void> delViewers(String channelId) async{
    try {
      await connection.query(
          "DELETE FROM Viewers WHERE(channel = '$channelId')");
    } on PostgreSQLException {
      print("error in delViewers");
    }
  }

}
