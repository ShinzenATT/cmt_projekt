import 'package:cmt_projekt/api/query_to_dbserver.dart';
import 'package:flutter/cupertino.dart';

class LoginModel {
  queryToDatabase databaseAPI = queryToDatabase();

  ///For LoginPageViewModel
  bool loginPassword = false; // Controlls the hide-password feature.
  String title = 'Comment'; //The website logotype.
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();

  ///For CreateAccountViewModel
  bool accountPassword = false; // Controlls the hide-password feature.
  TextEditingController createemail = TextEditingController();
  TextEditingController createphone = TextEditingController();
  TextEditingController createpassword = TextEditingController();
  TextEditingController createpassword2 = TextEditingController();
}
