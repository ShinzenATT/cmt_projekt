
import 'dart:io';

import 'package:alfred/alfred.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/models/query_model.dart';
import 'package:postgres/postgres.dart';

import '../database_server.dart';

/// A HTTP controller for handling requests regarding accounts
class AccountController {
  /// A handler for receiving data and creates a new account
  ///
  /// **Request Body** a [QueryModel] that contains email, password, phone & username.
  ///
  /// **Response Body** a [QueryModel] that contains account info except password and channel info.
  ///
  /// **Error Status Codes** when it's executed successfully then 200 ok is returned,
  /// 400 when the request body doesn't contain the expected values &
  /// 409 when phone or email is already taken.
  static register(HttpRequest req, HttpResponse res) async {
    final QueryModel body;
    final Map<String, dynamic> data;

    try {
      body = QueryModel.fromJson(await req.bodyAsJsonMap);
      data = await db.createAccount(body.email!, body.password!, body.phone!, body.username!);
    }
    on PostgreSQLException catch(e){ // account already exists
      logger.e(e.message, [e, e.stackTrace]);
      res.statusCode = HttpStatus.conflict;
      return e.message;
    }
    catch (e) { // body doesn't contain the needed values
      logger.e(e);
      res.statusCode = HttpStatus.badRequest;
      return e.toString();
    }

    return data;
  }

  /// Compares the credentials and on match it returns account info.
  ///
  /// **Request Body** a [QueryModel] that contains password and either email or phone.
  ///
  /// **Response Body** a [QueryModel] that contains account info except password and channel info.
  ///
  /// **Error Status Codes** when it's executed successfully then 200 ok is returned,
  /// 400 when the request body doesn't contain the expected values &
  /// 404 when the user is not found or password does not match.
  static login(HttpRequest req, HttpResponse res) async {
    final QueryModel body;
    final Map<String, dynamic>? data;

    try {
      body = QueryModel.fromJson(await req.bodyAsJsonMap);
      data = await db.compareCredentials(body.email ?? body.phone!, body.password!);

      // when credentials don't match, check mail and phone number
      if (data == null) {
        res.statusCode = HttpStatus.notFound;
        if (await db.accountExists(body.email ?? body.phone!)) {
          return 'Lösenordet stämmer ej överens med den angivna mejladressen/mobilnumret';
        }
        else {
          return 'Inget konto är kopplat till den angivna mejladressen/mobilnumret';
        }
      }
    }
    on PostgreSQLException catch (e) { // 500 on some db error
      logger.e(e.message, [e, e.stackTrace]);
      res.statusCode = HttpStatus.internalServerError;
      return null;
    }
    catch (e) { // when body doesn't contains email/phone and password
      logger.e(e);
      res.statusCode = HttpStatus.badRequest;
      return e.toString();
    }
    return data;
  }
}
