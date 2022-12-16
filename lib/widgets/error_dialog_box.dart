import 'package:flutter/material.dart';

class ErrorDialogBox {

  Future<void> pop(BuildContext context, String text) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ett fel inträffade"),
          content: Text(text),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            },
                child: const Text("Ok")),
          ],
        );
      },
    );
  }
}