import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/model/query_model.dart';
import 'package:postgres/postgres.dart';

import '../database_server.dart';

/// A HTTP controller for handling requests regarding handling viewers for channels
class ChannelViewersController {

  /// Adds a viewer for a channel to the db.
  ///
  /// **Request Body** a [QueryModel] that contains uid of viewer and channelid.
  ///
  /// **Error Status Codes** when it's executed successfully then 200 ok is returned,
  /// 400 when the request body doesn't contain the expected values &
  /// 409 when viewer already watched that channel.
  static addViewer(HttpRequest req, HttpResponse res) async {
    final QueryModel body;

    try {
      body = QueryModel.fromJson(await req.bodyAsJsonMap);
      await db.insertViewer(body.uid!, body.channelid!);
    }
    on PostgreSQLException catch (e) { // when combination of uid and channelid already exists
      logger.e(e.message, [e, e.stackTrace]);
      res.statusCode = HttpStatus.conflict;
      return e.message;
    }
    catch (e) { // when uid or channelid is not in request body
      logger.e(e);
      res.statusCode = HttpStatus.badRequest;
      return e.toString();
    }

    return null;
  }

  /// removes a viewer so it no longer watched the channel.
  ///
  /// **Request Body** a [QueryModel] that contains uid of viewer and channelid.
  ///
  /// **Error Status Codes** when it's executed successfully then 200 ok is returned &
  /// 400 when the request body doesn't contain the expected values.
  static deleteViewer(HttpRequest req, HttpResponse res) async {
    final QueryModel body;

    try {
      body = QueryModel.fromJson(await req.bodyAsJsonMap);
      await db.delViewer(body.uid!, body.channelid!);
    }
    on PostgreSQLException catch (e) { // on db errors
      logger.e(e.message, [e, e.stackTrace]);
      res.statusCode = HttpStatus.internalServerError;
      return e.message;
    }
    catch (e) { // when uid and channelid is not in request body
      logger.e(e);
      res.statusCode = HttpStatus.badRequest;
      return e.toString();
    }

    return null;
  }

  /// Clears all viewers from a channel.
  ///
  /// **Request Body** a [QueryModel] that contains channelid.
  ///
  /// **Error Status Codes** when it's executed successfully then 200 ok is returned &
  /// 400 when the request body doesn't contain the expected values.
  static deleteAllViewers(HttpRequest req, HttpResponse res) async {
    final QueryModel body;

    try {
      body = QueryModel.fromJson(await req.bodyAsJsonMap);
      await db.delViewers(body.channelid!);
    }
    on PostgreSQLException catch (e) { // on db errors
      logger.e(e.message, [e, e.stackTrace]);
      res.statusCode = HttpStatus.internalServerError;
      return e.message;
    }
    catch (e) { // when channelid is not in request body
      logger.e(e);
      res.statusCode = HttpStatus.badRequest;
      return e.toString();
    }

    return null;
  }
}
