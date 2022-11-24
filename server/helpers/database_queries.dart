import 'dart:convert';

import 'package:dbcrypt/dbcrypt.dart';
import 'package:postgres/postgres.dart';

import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/environment.dart';

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

  Future<Map<String, dynamic>?> compareCredentials(String login, String pass) async {
      final results = await connection.mappedResultsQuery(
          "SELECT password FROM Account WHERE (email = '$login' OR phone = '$login')");
      if (results.length == 1 && DBCrypt().checkpw(pass, results[0]["account"]!["password"] as String)) {
        return getInfo(login);
      }
      return null;
  }

  Future<Map<String, dynamic>> createAccount(String email, String pass, String phone, String username) async {
      await connection
          .query("INSERT INTO Account VALUES('$email', '$pass', '$phone', '$username')");
      return (getInfo(email));
  }

  Future<Map<String, dynamic>> getInfo(String login) async {
      final results = await connection.mappedResultsQuery(
          "SELECT email, uid, phone, username FROM Account WHERE ((email = '$login' OR phone = '$login'))");

      if (results.isEmpty) {
        throw Exception("Account does not exist");
      }

      ///The result is a List<List><dynamic>> which means that result.first[0] gives the first List<dynamic> which is the first row.
      ///After which each element in the row is compared to the right variable.
      logger.d(results);
      return results[0]['account'] as Map<String, dynamic>;
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
