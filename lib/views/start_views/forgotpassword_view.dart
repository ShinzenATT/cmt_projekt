import 'package:flutter/material.dart';

/// This view is used to help the user recover a forgotten password. Appears when
/// the user clicks the "forgot password" link in login.
class AppForgotPasswordPage extends StatefulWidget {
  /// A const constructor for [AppForgotPasswordPage]
  const AppForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _AppForgotPasswordPageState createState() => _AppForgotPasswordPageState();
}

class _AppForgotPasswordPageState extends State<AppForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
