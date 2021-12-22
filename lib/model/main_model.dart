import 'package:cmt_projekt/api/database_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
/*  List<DropdownMenuItem<String>>? categoryList = [
    DropdownMenuItem(child: Text('Sport')),
    DropdownMenuItem(child: Text('Rock')),
    DropdownMenuItem(child: Text('Jazz')),
    DropdownMenuItem(child: Text('Pop')),
    DropdownMenuItem(child: Text('Tjööt')),
  ];*/
  final categoryAndStandardImg = {
    'Rock':
        'https://images.unsplash.com/photo-1459305272254-33a7d593a851?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    'Sport':
        'https://images.unsplash.com/photo-1448387473223-5c37445527e7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80',
    'Jazz':
        'https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80,',
    'Pop':
        'https://images.unsplash.com/photo-1513151233558-d860c5398176?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
    'Tjööt':
        'https://images.unsplash.com/photo-1577563908411-5077b6dc7624?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80'
  };
  String? category;

  ///For Channelsettings
  TextEditingController channelName = TextEditingController();
}
