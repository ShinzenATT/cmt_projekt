import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';

/// A desktop page for restoring a forgotten password
class WebForgotPasswordPage extends StatefulWidget {
  /// constructs the [WebForgotPasswordPage]
  const WebForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _WebForgotPasswordPageState createState() => _WebForgotPasswordPageState();
}

class _WebForgotPasswordPageState extends State<WebForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GradientElevatedButton(
        child: const Text('Hej'),
        onPressed: () {},
        gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black,
              Colors.blueAccent,
            ]),
      ),
    );
  }
}
