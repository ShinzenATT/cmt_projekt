import 'package:cmt_projekt/model/loginmodel.dart';
import 'package:cmt_projekt/model/querymodel.dart';
import 'package:flutter/material.dart';

///View model for CreateAccountwidget and page.
class CreateAccountViewModel with ChangeNotifier {
  LoginModel lm = LoginModel();

  void changePasswordVisibility() {
    lm.accountPassword = !lm.accountPassword;
    notifyListeners();
  }

  get accountPassword => lm.accountPassword;
  get email => lm.createemail;
  get phone => lm.createphone;
  get password1 => lm.createpassword;
  get password2 => lm.createpassword2;
  get client => lm.databaseAPI;
  void comparePw(var context) {
    if (password1.value.text == password2.value.text) {
      createAccount();
      Navigator.of(context, rootNavigator: true)
          .pop(); // Poppar Dialogrutan och gör så att den nuvarande rutan är loginpage.
      Navigator.of(context)
          .pushReplacementNamed('/Home'); // Byter till homepage.
    }
  }

  void createAccount() {
    client.sendRequest(QueryModel(
        email: email.value.text,
        phone: phone.value.text,
        password: password1.value.text));
  }
}
