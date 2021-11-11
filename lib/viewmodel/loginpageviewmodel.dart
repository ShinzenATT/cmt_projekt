import 'package:cmt_projekt/model/loginmodel.dart';
import 'package:flutter/material.dart';

class LoginPageViewModel with ChangeNotifier {
  LoginModel lm = LoginModel();

  void changePasswordVisibility() {
    lm.loginPassword = !lm.loginPassword;
    notifyListeners();
  }

  get loginPassword => lm.loginPassword;
  get title => lm.title;

  void changePage(var context) {
    Navigator.of(context).pushReplacementNamed('/Home');
  }
}
