import 'package:cmt_projekt/api/navigation_handler.dart';
import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/app/View/app_channelsettings.dart';
import 'package:cmt_projekt/app/View/app_profilepage.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/model/categorymodel.dart';
import 'package:cmt_projekt/model/model.dart';
import 'package:cmt_projekt/model/querymodel.dart';
import 'package:cmt_projekt/website/View/web_channelsettings.dart';
import 'package:cmt_projekt/website/View/web_profilewidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

///View model för Homepage och profilewidget.
class VM with ChangeNotifier {
  Model lm = Model();

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
    /* if (getEmail() == null) {
      return;
    } */
    if (kIsWeb) {
      showDialog(
          context: context,
          builder: (context) {
            return const WebProfileWidget();
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const AppProfileWidget();
          });
    }
  }

  void channelSettings(context) {
    /*    if (getEmail() == null) {
      return;
    } */
    if (kIsWeb) {
      showDialog(
          context: context,
          builder: (context) {
            return WebChannelSettings();
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AppChannelSettings();
          });
    }
  }

  void logOut(context) {
    Prefs().storedData.clear();
    NaviHandler().index = 1;
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

  /*
    From loginpageviewmodel
   */
  void changePasswordVisibility() {
    lm.passwordVisibilityLogin = !lm.passwordVisibilityLogin;
    notifyListeners();
  }
  /*
    From loginpageviewmodel
   */
  get passwordVisibilityLogin => lm.passwordVisibilityLogin;
  String get title => lm.title;
  get login => lm.login;
  get password => lm.password;
  get databaseAPI => lm.databaseAPI;

  /*
    From loginpageviewmodel
   */
  void changePage(var context, String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  /*
    From loginpageviewmodel
   */
  void loginAttempt(context) async {
    setUpResponseStream(context);
    lm.databaseAPI.sendRequest(QueryModel.login(
        email: login.value.text, password: password.value.text));
  }

  /*
    From loginpageviewmodel
   */
  void guestSign(context) async {
    setUpResponseStream(context);
    Prefs().storedData.setString("uid", const Uuid().v4());
    Prefs().storedData.get("uid");
  }

  /*
    From loginpageviewmodel
   */
  ///Sätter upp funktionen som skall köras när ett nytt värde kommer ut ifrån response strömmmen.
  void setUpResponseStream(context) {
    lm.databaseAPI.streamController.stream.listen((value) {
      if (value) {
        // Poppar Dialogrutan och gör så att den nuvarande rutan är loginpage.
        Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
        //Navigator.of(context)
        //    .pushReplacementNamed('/Home'); // Byter till homepage.
      }
    });
  }
}
