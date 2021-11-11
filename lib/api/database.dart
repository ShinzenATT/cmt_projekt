import 'package:postgrest/postgrest.dart';

class Database {
  //Database host ip
  final url = 'http://192.168.10.106:3000';


  //Creates a row on the selected "table"
  void insert(String email, String password, String phone) async {
    try {
      var client = PostgrestClient(url);
      var response = await client.from('users').insert([
        {
          'email': email,
          'password': password,
          'phone': phone
        }
      ]).execute();
      print(response.status);
      print(response.data);
    } on Error {
      throw Exception("Error: Something went wrong: $Exception");
    }

  }

  //Reads data from the selected table
  void read(String type, String login, String password) async {
    try {
      var client = PostgrestClient(url);
      var response;
      response = await client.from('users').select().eq(type, login).eq('password', password).execute();
      print(response.status);
      print(response.data);
    } on Error {
      throw Exception("Error: Something went wrong: $Exception");
    }
  }

}