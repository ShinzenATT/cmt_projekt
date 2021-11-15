import 'package:cmt_projekt/model/loginmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart' as constant;

///View model for CreateAccountwidget and page.
class CreateAccountViewModel with ChangeNotifier {
  LoginModel lm = LoginModel();

  void changePasswordVisibility() {
    lm.passwordVisibilityCreate = !lm.passwordVisibilityCreate;
    notifyListeners();
  }

  get passwordVisibilityCreate => lm.passwordVisibilityCreate;
  get email => lm.createEmail;
  get phone => lm.createPhone;
  get password1 => lm.createPassword;
  get password2 => lm.createPassword2;

  void comparePw(var context) {
    if (password1.value.text == password2.value.text) {
      if (kIsWeb) {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Poppar Dialogrutan och gör så att den nuvarande rutan är loginpage.
        Navigator.of(context)
            .pushReplacementNamed(constant.home); // Byter till homepage.
      }else{
        Navigator.of(context)
            .pushReplacementNamed(constant.home);
      }
    }
  }
}
