import 'package:cmt_projekt/model/loginmodel.dart';
import 'package:flutter/material.dart';



class LoginPageViewModel with ChangeNotifier {
  LoginModel lm = LoginModel();

  void changePasswordVisibility() {
    lm.passwordVisibilityLogin = !lm.passwordVisibilityLogin;
    notifyListeners();
  }

  get passwordVisibilityLogin => lm.passwordVisibilityLogin;
  get title => lm.title;
  get login => lm.login;
  get password => lm.password;

  void changePage(var context, String route) {
    Navigator.of(context).pushReplacementNamed(route);
  }
}
