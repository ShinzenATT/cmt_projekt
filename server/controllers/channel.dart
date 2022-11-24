import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/model/query_model.dart';
import 'package:postgres/postgres.dart';

import '../database_server.dart';

class ChannelController {

  static getChannels(HttpRequest req, HttpResponse res) async {
    try {
      return await db.getOnlineChannels();
    } on PostgreSQLException catch(e){
      logger.e(e.message, [e, e.stackTrace]);
      res.statusCode = HttpStatus.internalServerError;
      return e.message;
    }
  }

  static addChannel(HttpRequest req, HttpResponse res) async {
    final QueryModel body;
    final List<Map<String, dynamic>> data;

    try {
      body = QueryModel.fromJson(await req.bodyAsJsonMap);
      await db.createChannel(body.channelname!, body.uid!, body.category!);
      data = await db.getOnlineChannels();
    }
    on PostgreSQLException catch (e){
      logger.e(e.message, [e, e.stackTrace]);
      res.statusCode = HttpStatus.badRequest;
      return e.message;
    }
    catch (e){
      logger.d(await req.body);
      logger.e(e);
      res.statusCode = HttpStatus.badRequest;
      return e.toString();
    }

    return data;
  }

  static makeOffline(HttpRequest req, HttpResponse res) async {
    final QueryModel body;
    final List<Map<String, dynamic>> data;

    try {
      body = QueryModel.fromJson(await req.bodyAsJsonMap);
      await db.goOffline(body.uid!);
      data = await db.getOnlineChannels();
    }
    on PostgreSQLException catch (e){
      logger.e(e.message, [e, e.stackTrace]);
      res.statusCode = HttpStatus.notFound;
      return e.message;
    }
    catch (e){
      logger.d(await req.body);
      logger.e(e);
      res.statusCode = HttpStatus.badRequest;
      return e.toString();
    }

    return data;
  }
}
