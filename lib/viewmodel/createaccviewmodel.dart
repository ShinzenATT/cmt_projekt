import 'package:cmt_projekt/model/loginmodel.dart';
import 'package:flutter/material.dart';

class CreateAccountViewModel with ChangeNotifier {
  LoginModel p = LoginModel();

  void changePasswordVisibility() {
    p.accountPassword = !p.accountPassword;
    notifyListeners();
  }

  get accountPassword => p.accountPassword;
}
