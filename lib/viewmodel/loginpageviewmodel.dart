import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/model/loginmodel.dart';
import 'package:cmt_projekt/model/querymodel.dart';
import 'package:flutter/material.dart';

class LoginPageViewModel with ChangeNotifier {
  LoginModel lm = LoginModel();

  void changePasswordVisibility() {
    lm.passwordVisibilityLogin = !lm.passwordVisibilityLogin;
    notifyListeners();
  }

  get passwordVisibilityLogin => lm.passwordVisibilityLogin;
  String get title => lm.title;
  get login => lm.login;
  get password => lm.password;
  get databaseAPI => lm.databaseAPI;

  void changePage(var context, String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }

  void loginAttempt(context) async {
    setUpResponseStream(context);
    lm.databaseAPI.sendRequest(QueryModel.login(
        email: login.value.text, password: password.value.text));
  }

  ///Sätter upp funktionen som skall köras när ett nytt värde kommer ut ifrån response strömmmen.
  void setUpResponseStream(context) {
    lm.databaseAPI.streamController.stream.listen((value) {
      if (value) {
        // Poppar Dialogrutan och gör så att den nuvarande rutan är loginpage.
        Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
        //Navigator.of(context)
        //    .pushReplacementNamed('/Home'); // Byter till homepage.
        lm.databaseAPI.sendRequest(QueryModel.userInfo(
            email: login.value.text, password: password.value.text));
      }
    });
  }
}
