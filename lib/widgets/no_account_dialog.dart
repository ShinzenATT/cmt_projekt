import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmt_projekt/view_models/main_vm.dart';

///AlertMessage when you are logged in as a guest.
///The guest is asked to create an account to get access to the functionality.
class AlertMessage extends StatelessWidget {
  const AlertMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Du har inget konto"),
      content: const Text(
          "Den här funktionen är bara tillgänglig om man är inloggad, var vänlig skapa ett konto."),
      actions: <Widget>[
        TextButton(
          child: const Text("Stäng"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
            Provider.of<MainVM>(context, listen: false).logOut(context);
          },
        ),
      ],
    );
  }
}