
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/model/query_model.dart';
import 'package:postgres/postgres.dart';

import '../database_server.dart';

class AccountController {
  static register(HttpRequest req, HttpResponse res) async {
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
}

static login(HttpRequest req, HttpResponse res) async {
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
  }
}
