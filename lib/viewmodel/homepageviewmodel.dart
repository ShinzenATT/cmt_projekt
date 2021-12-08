import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/website/View/web_profilewidget.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

///View model för Homepage och profilewidget.
class HomePageViewModel with ChangeNotifier {
  ///Returnerar användarens email.
  String? getEmail() {
    return Prefs().storedData.getString("email");
  }

  ///Returnerar användarens uID.
  String? getUid() {
    String s = Prefs().storedData.getString("uid")??(PostgreSQLDataType.uuid.toString());
    print(s);
    return s;
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
