import 'package:cmt_projekt/api/database_api.dart';
import 'package:cmt_projekt/api/navigation_handler.dart';
import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/app/View/app_channelsettings.dart';
import 'package:cmt_projekt/app/View/app_profilepage.dart';
import 'package:cmt_projekt/constants.dart';
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

  get categoryList => lm.categoryList;
  get getCategory => lm.category;
  void setCategory(var item) {
    lm.category = item;
  }

  get passwordVisibilityLogin => lm.passwordVisibilityLogin;
  get login => lm.login;
  get password => lm.password;
  get databaseAPI => lm.databaseAPI;

  bool get passwordVisibilityCreate => lm.passwordVisibilityCreate;
  get title => lm.title.toUpperCase();
  TextEditingController get email => lm.createEmail;
  TextEditingController get phone => lm.createPhone;
  TextEditingController get password1 => lm.createPassword;
  TextEditingController get password2 => lm.createPassword2;
  DatabaseApi get client => lm.databaseAPI;

  TextEditingController get channelName => lm.channelName;

  void printChannelName() {
    print(channelName.value.text);
    print(getCategory);
  }

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

  /// From loginpageviewmodel
  void changePasswordVisibilityLogin() {
    lm.passwordVisibilityLogin = !lm.passwordVisibilityLogin;
    notifyListeners();
  }

  /// From loginpageviewmodel
  void changePage(var context, String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  /// From loginpageviewmodel
  void loginAttempt(context) async {
    setUpResponseStreamLogin(context);
    lm.databaseAPI.sendRequest(QueryModel.login(
        email: login.value.text, password: password.value.text));
  }

  /// From loginpageviewmodel
  void guestSign(context) async {
    setUpResponseStreamLogin(context);
    Prefs().storedData.setString("uid", const Uuid().v4());
    Prefs().storedData.get("uid");
  }

  /// From loginpageviewmodel
  ///Sätter upp funktionen som skall köras när ett nytt värde kommer ut ifrån response strömmmen.
  void setUpResponseStreamLogin(context) {
    lm.databaseAPI.streamController.stream.listen((value) {
      if (value) {
        // Poppar Dialogrutan och gör så att den nuvarande rutan är loginpage.
        Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
        //Navigator.of(context)
        //    .pushReplacementNamed('/Home'); // Byter till homepage.
      }
    });
  }

  /// From createaccountviewmodel
  void changePasswordVisibilityCreate() {
    lm.passwordVisibilityCreate = !lm.passwordVisibilityCreate;
    notifyListeners();
  }


  /// From createaccountviewmodel
  void comparePw(var context) {
    if (password1.value.text == password2.value.text) {
      setUpResponseStreamCA(context);
      createAccount();
    }
  }

  /// From createaccountviewmodel
  ///Sätter upp funktionen som skall köras när ett nytt värde kommer ut ifrån response strömmmen.
  void setUpResponseStreamCA(context) {
    client.streamController.stream.listen((value) {
      var _context = context;
      if (value) {
        if (kIsWeb) {
          // Poppar Dialogrutan och gör så att den nuvarande rutan är loginpage.
          Navigator.of(_context, rootNavigator: true).pop();
        }

        Navigator.of(_context)
            .pushReplacementNamed('/Home'); // Byter till homepage.
      }
    });
  }

  /// From createaccountviewmodel
  void createAccount() {
    client.sendRequest(
      QueryModel.account(
          email: email.value.text,
          phone: phone.value.text,
          password: password1.value.text),
    );
  }
}
