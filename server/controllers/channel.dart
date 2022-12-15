import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/models/channel_data_model.dart';
import 'package:cmt_projekt/models/query_model.dart';
import 'package:postgres/postgres.dart';

import '../database_server.dart';

/// A HTTP controller for handling requests regarding channels
class ChannelController {

  /// Gets all the available channels and responds with them as a List.
  ///
  /// **Response Body** a [List<ChannelDataModel>] that contains a list of channels but excluding account info.
  ///
  /// **Error Status Codes** when it's executed successfully then 200 ok is returned &
  /// 500 on a exception or database error.
  static getChannels(HttpRequest req, HttpResponse res) async {
    try {
      return await db.getOnlineChannels();
    } on PostgreSQLException catch(e){ // on db errors
      logger.e(e.message, [e, e.stackTrace]);
      res.statusCode = HttpStatus.internalServerError;
      return e.message;
    }
  }

  /// Adds a channel to the database where a db trigger handles if a new is
  /// to be made or updates a existing one.
  ///
  /// **Request Body** a [ChannelDataModel] that contains channelname, uid and category.
  ///
  /// **Response Body** a [ChannelDataModel] that contains the channel without account info.
  ///
  /// **Error Status Codes** when it's executed successfully then 200 ok is returned,
  /// 400 when the request body doesn't contain the expected values &
  /// 404 when uid doesn't match an account.
  static addChannel(HttpRequest req, HttpResponse res) async {
    final ChannelDataModel body;
    final Map<String, dynamic> data;

    try {
      body = ChannelDataModel.parseMap(await req.bodyAsJsonMap);
      await db.createChannel(body);
      data = await db.getChannel(body.channelid);
    }
    on PostgreSQLException catch (e){ // when uid does not match an account
      logger.e(e.message, e);
      res.statusCode = HttpStatus.notFound;
      return e.message;
    }
    catch (e){ // when channelname, uid or category is not on the request body
      logger.d(await req.body);
      logger.e(e);
      res.statusCode = HttpStatus.badRequest;
      return e.toString();
    }

    return data;
  }

  /// Marks a channel as offline on the db.
  ///
  /// **Request Body** a [QueryModel] that contains the channelid in the uid field.
  ///
  /// **Response Body** a [ChannelDataModel] that contains the channel without account info.
  ///
  /// **Error Status Codes** when it's executed successfully then 200 ok is returned,
  /// 400 when the request body doesn't contain the expected values &
  /// 404 when uid doesn't match a channel.
  static makeOffline(HttpRequest req, HttpResponse res) async {
    final QueryModel body;
    final Map<String, dynamic> data;

    try {
      body = QueryModel.fromJson(await req.bodyAsJsonMap);
      await db.goOffline(body.uid!);
      data = await db.getChannel(body.uid!);
    }
    on PostgreSQLException catch (e){ // when uid does not match a channel
      logger.e(e.message, [e, e.stackTrace]);
      res.statusCode = HttpStatus.notFound;
      return e.message;
    }
    catch (e){ // when uid is not in request body
      logger.d(await req.body);
      logger.e(e);
      res.statusCode = HttpStatus.badRequest;
      return e.toString();
    }

    return data;
  }
}
