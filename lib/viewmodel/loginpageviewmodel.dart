import 'package:cmt_projekt/model/loginmodel.dart';
import 'package:flutter/material.dart';

class LoginPageViewModel with ChangeNotifier {
  LoginModel p = LoginModel();

  void changePasswordVisibility() {
    p.loginPassword = !p.loginPassword;
    notifyListeners();
  }

  get loginPassword => p.loginPassword;
  get title => p.title;
}
