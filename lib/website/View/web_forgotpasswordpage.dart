import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';

class WebForgotPasswordPage extends StatefulWidget {
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
        child: Text('Hej'),
        onPressed: () {},
        gradient: LinearGradient(
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
