import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/main_vm.dart';
import '../view_models/stream_vm.dart';
import 'dialog_timer.dart';

/// A dialog that shows up when a stream has ended. It has a timer and 2 buttons for navigation.
class ChannelClosedDialog extends StatelessWidget{
  /// Sets the page key
  const ChannelClosedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      child: Container(
        height: MediaQuery.of(context).size.height*0.4,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.greenAccent,
                  Colors.blueAccent,
                ])
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text('Sändningen är avslutad',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Text('Byter till ny kanal om:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const DialogTimer(time: 10,), //change textstyle in widget
            ElevatedButton(
              onPressed: () {
                context.read<StreamViewModel>().closeClient();
                context.read<MainViewModel>().willPopCallback();
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black45),
                  foregroundColor: MaterialStateProperty.all(Colors.white)
              ),
              child: const Text('Tillbaka till startsidan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black45),
                  foregroundColor: MaterialStateProperty.all(Colors.white)
              ),
              child: const Text('Byt kanal',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
