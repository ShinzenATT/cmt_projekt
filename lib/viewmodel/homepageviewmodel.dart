import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/website/View/web_profilewidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///View model för Homepage och profilewidget.
class HomePageViewModel with ChangeNotifier {
  ///Returnerar användarens email.
  String? getEmail() {
    return Prefs().storedData.getString("email");
  }

  ///Returnerar användarens uID.
  String? getUid() {
    print(Prefs().storedData.getString("uid"));
    return Prefs().storedData.getString("uid");
  }

  /// Skapar en showdialog med webprofilewidget.
  void profileInformation(context) {
    showDialog(
        context: context,
        builder: (context) {
          return const WebProfileWidget();
        });
  }
}
