import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/model/query_model.dart';
import 'package:postgres/postgres.dart';

import '../database_server.dart';

class ChannelViewersController {
  static addViewer(HttpRequest req, HttpResponse res) async {
    final QueryModel body;

    try {
      body = QueryModel.fromJson(await req.bodyAsJsonMap);
      await db.insertViewer(body.uid!, body.channelid!);
    }
    on PostgreSQLException catch (e) {
      logger.e(e.message, [e, e.stackTrace]);
      res.statusCode = HttpStatus.conflict;
      return e.message;
    }
    catch (e) {
      logger.e(e);
      res.statusCode = HttpStatus.badRequest;
      return e.toString();
    }

    return null;
  }

  static deleteViewer(HttpRequest req, HttpResponse res) async {
    final QueryModel body;

    try {
      body = QueryModel.fromJson(await req.bodyAsJsonMap);
      await db.delViewer(body.uid!, body.channelid!);
    }
    on PostgreSQLException catch (e) {
      logger.e(e.message, [e, e.stackTrace]);
      res.statusCode = HttpStatus.notFound;
      return e.message;
    }
    catch (e) {
      logger.e(e);
      res.statusCode = HttpStatus.badRequest;
      return e.toString();
    }

    return null;
  }

  static deleteAllViewers(HttpRequest req, HttpResponse res) async {
    final QueryModel body;

    try {
      body = QueryModel.fromJson(await req.bodyAsJsonMap);
      await db.delViewers(body.channelid!);
    }
    on PostgreSQLException catch (e) {
      logger.e(e.message, [e, e.stackTrace]);
      res.statusCode = HttpStatus.notFound;
      return e.message;
    }
    catch (e) {
      logger.e(e);
      res.statusCode = HttpStatus.badRequest;
      return e.toString();
    }

    return null;
  }
}
