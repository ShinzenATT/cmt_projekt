import 'package:cmt_projekt/model/loginmodel.dart';
import 'package:cmt_projekt/model/querymodel.dart';
import 'package:flutter/material.dart';

class LoginPageViewModel with ChangeNotifier {
  LoginModel lm = LoginModel();

  void changePasswordVisibility() {
    lm.loginPassword = !lm.loginPassword;
    notifyListeners();
  }

  get loginPassword => lm.loginPassword;
  get title => lm.title;
  get login => lm.login;
  get password => lm.password;
  get databaseAPI => lm.databaseAPI;

  void changePage(var context) {
    Navigator.of(context).pushReplacementNamed('/Home');
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
        Navigator.of(context)
            .pushReplacementNamed('/Home'); // Byter till homepage.
      }
    });
  }
}
