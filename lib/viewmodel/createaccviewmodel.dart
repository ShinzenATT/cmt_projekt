import 'package:cmt_projekt/model/loginmodel.dart';
import 'package:cmt_projekt/model/querymodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  get client => lm.databaseAPI;
  void comparePw(var context) {
    if (password1.value.text == password2.value.text) {
      setUpResponseStream(context);
      createAccount();
    }
  }

  ///Sätter upp funktionen som skall köras när ett nytt värde kommer ut ifrån response strömmmen.
  void setUpResponseStream(context) {
    lm.databaseAPI.streamController.stream.listen((value) {
      var _context = context;
      if (value) {
        Navigator.of(_context, rootNavigator: true)
            .pop(); // Poppar Dialogrutan och gör så att den nuvarande rutan är loginpage.
        Navigator.of(_context)
            .pushReplacementNamed('/Home'); // Byter till homepage.
      }
    });
  }

  void createAccount() {
    client.sendRequest(QueryModel(
        email: email.value.text,
        phone: phone.value.text,
        password: password1.value.text));
  }
}
