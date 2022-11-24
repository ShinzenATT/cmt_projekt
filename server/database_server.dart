import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:alfred/alfred.dart';
import 'package:cmt_projekt/model/query_model.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/environment.dart';

import 'helpers/database_queries.dart';

final server = Alfred();

void main() async {
  DatabaseServer();
}

class DatabaseServer {
  DatabaseQueries db = DatabaseQueries();

  DatabaseServer(){
    initRoutes();

    server.listen(5604, '0.0.0.0')
        .then((s) =>
        logger.i('Database server served under http://${s.address.address}:${s.port} \n'
            '(0.0.0.0 means all ips are accepted, which includes localhost)'
        ));
  }

  initRoutes(){
    server.post("account/register", (req, res) async {
      final QueryModel body;
      final Map<String, dynamic> data;

      try {
        body = QueryModel.fromJson(await req.bodyAsJsonMap);
        data = await db.createAccount(body.email!, body.password!, body.phone!, body.username!);
      }
      on PostgreSQLException catch(e){
        logger.e(e.message, [e, e.stackTrace]);
        res.statusCode = HttpStatus.conflict;
        return e.message;
      }
      catch (e) {
        logger.e(e);
        res.statusCode = HttpStatus.badRequest;
        return e.toString();
      }

      return data;
    });

    server.post("account/login", (req, res) async {
      final QueryModel body;
      final Map<String, dynamic>? data;

      try{
        body = QueryModel.fromJson(await req.bodyAsJsonMap);
        data = await db.compareCredentials(body.email!, body.password!);
      }
      on PostgreSQLException catch (e){
        logger.e(e.message, [e, e.stackTrace]);
        res.statusCode = HttpStatus.internalServerError;
        return null;
      }
      catch(e) {
        logger.e(e);
        res.statusCode = HttpStatus.badRequest;
        return e.toString();
      }

      if(data == null){
        res.statusCode = HttpStatus.notFound;
        return 'credentials mismatch';
      }
      return data;
    });

    server.get("/channel", (req, res) async {
      try {
        return await db.getOnlineChannels();
      } on PostgreSQLException catch(e){
        logger.e(e.message, [e, e.stackTrace]);
        res.statusCode = HttpStatus.internalServerError;
        return e.message;
      }
    });

    server.post('/channel', (req, res) async {
      final QueryModel body;
      final List<Map<String, dynamic>> data;

      try {
        body = QueryModel.fromJson(await req.bodyAsJsonMap);
        await db.createChannel(body.channelName!, body.uid!, body.category!);
        data = await db.getOnlineChannels();
      } on PostgreSQLException catch (e){
        logger.e(e.message, [e, e.stackTrace]);
        res.statusCode = HttpStatus.badRequest;
        return e.message;
      } catch (e){
        logger.e(e);
        res.statusCode = HttpStatus.badRequest;
        return e.toString();
      }

      return data;
    });

    server.delete("/channel", (req, res) async {
      final QueryModel body;
      final List<Map<String, dynamic>> data;

      try {
        body = QueryModel.fromJson(await req.bodyAsJsonMap);
        await db.goOffline(body.uid!);
        data = await db.getOnlineChannels();
      } on PostgreSQLException catch (e){
        logger.e(e.message, [e, e.stackTrace]);
        res.statusCode = HttpStatus.notFound;
        return e.message;
      } catch (e){
        logger.e(e);
        res.statusCode = HttpStatus.badRequest;
        return e.toString();
      }

      return data;
    });
  }
}

/// Creates a connection between the database and the application.
class DatabaseServerOld {
  DatabaseQueries db = DatabaseQueries();
  late HttpServer server;
  Map<WebSocketChannel, StreamController> connectedClients = {};

  DatabaseServerOld() {
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

    /*switch (query.code) {
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
    }*/
  }
}


