import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/website/View/web_profilewidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageViewModel with ChangeNotifier {
  String? getEmail() {
    //print(Prefs().storedData.getString("email"));
    return Prefs().storedData.getString("email");
  }

  String? getUid() {
    print(Prefs().storedData.getString("uid"));
    return Prefs().storedData.getString("uid");
  }

  void profileInformation(context) {
    showDialog(
        context: context,
        builder: (context) {
          return const WebProfileWidget();
        });
  }
}
