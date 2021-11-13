import 'package:postgres/postgres.dart';

class Database {
  //Database host ip

  Future<void> read(String login, String pass) async {
    var connection = PostgreSQLConnection(
        "188.150.156.238", 5432, "cmt_projekt",
        username: "pi", password: "Kastalagatan22");
    await connection.open();

    List<List<dynamic>> results = await connection.query(
        "SELECT email, phone FROM users WHERE ((email = '$login' OR phone = '$login') AND (password = '$pass'))");

    for (final row in results) {
      var email = row[0];
      var phone = row[1];
      print(email);
      print(phone);
    }
  }

  Future<void> createAccount(String email, String pass, String phone) async {
    var connection = PostgreSQLConnection(
        "188.150.156.238", 5432, "cmt_projekt",
        username: "pi", password: "Kastalagatan22");
    await connection.open();

    List<List<dynamic>> results = await connection
        .query("INSERT INTO users VALUES('$email', '$pass', '$phone')");
    print(email);
    print(phone);
    print(results);
  }
}
