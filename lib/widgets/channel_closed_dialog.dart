import 'package:cmt_projekt/view_models/navigation_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:cmt_projekt/widgets/dialog_timer.dart';
import '../models/navigation_model.dart';

/// A dialog that shows up when a stream has ended. It has a timer and 2 buttons for navigation.
class ChannelClosedDialog extends StatelessWidget{
  /// Sets the page key
  const ChannelClosedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    NavVM navVM = Provider.of<NavVM>(context);

    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
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
                context.read<StreamVM>().closeClient();
                Navigator.of(context).pop();
                navVM.selectTab(TabId.home);
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
