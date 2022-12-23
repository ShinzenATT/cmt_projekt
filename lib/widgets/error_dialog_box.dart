import 'package:flutter/material.dart';

/// This class if for displaying an error dialog
class ErrorDialogBox {

  /// Displays an error dialog with the inputted text argument
  Future<void> show(BuildContext context, String text) {
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
