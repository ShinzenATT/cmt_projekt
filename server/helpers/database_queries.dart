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
      await connection.query(
          "INSERT INTO channelview VALUES('$uid','$channelName','$category')");
  }

  Future<List<Map<String, dynamic>>> getOnlineChannels() async {
      final results = await connection.mappedResultsQuery(
          "SELECT category, channelid, channelname, isonline, username, (SELECT COUNT('*') as total FROM Viewers WHERE channel = channelid) FROM Channel JOIN Account on uid = channelid;");

      List<Map<String, dynamic>> response = [];

      for(final row in results){
        Map<String, dynamic> m = {};
        m.addAll(row[""]!);
        m.addAll(row["account"]!);
        m.addAll(row["channel"]!);
        response.add(m);
      }

      return response;
  }

  Future<void> insertViewer(String uid, String channelId) async{
      await connection.query(
          "INSERT INTO Viewers VALUES('$uid','$channelId')");
  }

  Future<void> delViewer(String uid, String channelId) async{
      await connection.query(
          "DELETE FROM Viewers WHERE(viewer = '$uid' AND channel = '$channelId')");
  }

  Future<void> delViewers(String channelId) async{
      await connection.query(
          "DELETE FROM Viewers WHERE(channel = '$channelId')");
  }

}
