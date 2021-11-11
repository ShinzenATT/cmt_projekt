import 'package:cmt_projekt/Model/loginpagemodel.dart';
import 'package:flutter/material.dart';

class LoginPageViewModel with ChangeNotifier {
  LoginPageModel p = LoginPageModel();

  void changePasswordVisibility() {
    p.loginPassword = !p.loginPassword;
    notifyListeners();
  }

  get loginPassword => p.loginPassword;
  get title => p.title;
}
