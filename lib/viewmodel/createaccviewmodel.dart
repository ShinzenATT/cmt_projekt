import 'package:cmt_projekt/model/loginmodel.dart';
import 'package:flutter/material.dart';

///View model for CreateAccountwidget and page.
class CreateAccountViewModel with ChangeNotifier {
  LoginModel lm = LoginModel();

  void changePasswordVisibility() {
    lm.accountPassword = !lm.accountPassword;
    notifyListeners();
  }

  get accountPassword => lm.accountPassword;
}
