import 'package:cmt_projekt/api/database_api.dart';
import 'package:flutter/cupertino.dart';

class Model {
  DatabaseApi databaseAPI = DatabaseApi();

  ///For LoginPage
  bool passwordVisibilityLogin = false; // Controlls the hide-password feature.
  String title = 'Comment'; //The website logotype.
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();

  ///For CreateAccount
  bool passwordVisibilityCreate = false; // Controlls the hide-password feature.
  TextEditingController createEmail = TextEditingController();
  TextEditingController createPhone = TextEditingController();
  TextEditingController createPassword = TextEditingController();
  TextEditingController createPassword2 = TextEditingController();

  ///For Category
  final categoryList = ['Sport', 'Rock', 'Jazz', 'Pop', 'Tjööt'];
  String? category;

  ///For Channelsettings
  TextEditingController channelName = TextEditingController();
}
