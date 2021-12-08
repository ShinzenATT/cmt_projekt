import 'package:cmt_projekt/api/database_api.dart';
import 'package:flutter/cupertino.dart';

class LoginModel {
  DatabaseApi databaseAPI = DatabaseApi();

  ///For LoginPageViewModel
  bool passwordVisibilityLogin = false; // Controlls the hide-password feature.
  String title = 'Comment'; //The website logotype.
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();

  ///For CreateAccountViewModel
  bool passwordVisibilityCreate = false; // Controlls the hide-password feature.
  TextEditingController createEmail = TextEditingController();
  TextEditingController createPhone = TextEditingController();
  TextEditingController createPassword = TextEditingController();
  TextEditingController createPassword2 = TextEditingController();
}