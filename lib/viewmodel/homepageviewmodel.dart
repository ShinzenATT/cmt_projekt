import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageViewModel with ChangeNotifier {
  late SharedPreferences prefs;

  Future<String?> getEmail() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }
}
