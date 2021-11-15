import 'package:postgres/postgres.dart';

class Database {
  //Database host ip

  Future<String> read(String login, String pass) async {
    var connection = PostgreSQLConnection("192.168.0.40", 5432, "cmt_projekt",
        username: "pi", password: "Kastalagatan22");
    await connection.open();

    List<List<dynamic>> results = await connection.query(
        "SELECT email, phone FROM users WHERE ((email = '$login' OR phone = '$login') AND (password = '$pass'))");
    if (results.isEmpty) {
      return "false";
    }
    return "true";
  }

  Future<String> createAccount(String email, String pass, String phone) async {
    try {
      var connection = PostgreSQLConnection("192.168.0.40", 5432, "cmt_projekt",
          username: "pi", password: "Kastalagatan22");
      await connection.open();

      List<List<dynamic>> results = await connection
          .query("INSERT INTO users VALUES('$email', '$pass', '$phone')");
      print(email);
      print(phone);
      print(results);
      return ("true");
    } on PostgreSQLException {
      return ("false");
    }
  }
}
