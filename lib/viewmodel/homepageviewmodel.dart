import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/app/View/app_channelsettings.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/model/categorymodel.dart';
import 'package:cmt_projekt/website/View/web_profilewidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///View model för Homepage och profilewidget.
class HomePageViewModel with ChangeNotifier {
  CategoryModel cmodel = CategoryModel();

  DropdownMenuItem<String> categoryItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );

  List<DropdownMenuItem<String>>? getItems() {
    notifyListeners();
    return categoryList.mapList(categoryItem).toList();
  }

  ///Returnerar användarens email.
  String? getEmail() {
    return Prefs().storedData.getString("email");
  }

  ///Returnerar användarens uID.
  String? getUid() {
    return Prefs().storedData.get("uid").toString();
  }

  /// Skapar en showdialog med webprofilewidget.
  void profileInformation(context) {
    showDialog(
        context: context,
        builder: (context) {
          return const WebProfileWidget();
        });
  }

  void channelSettings(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AppChannelSettings();
        });
  }

  void logOut(context) {
    Prefs().storedData.clear();
    if (kIsWeb) {
      Navigator.of(context).pushReplacementNamed(login);
    } else {
      Navigator.of(context).pushReplacementNamed(appWelcome);
    }
  }

  get categoryList => cmodel.categoryList;
  get getCategory => cmodel.category;
  void setCategory(var item) {
    cmodel.category = item;
  }
}
