import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/buttons/gradient_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:cmt_projekt/view_models/navigation_vm.dart';
import 'package:cmt_projekt/constants.dart' as constants;

/// This view is a selector for which type of stream the user intends to do such as
/// audio or video. This view is connected to the go live tab in the bottom navigation.
class GoLiveView1 extends StatelessWidget {
  /// A const constructor for [GoLiveView1]
  const GoLiveView1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /*
      if(Prefs().getEmail() == null) {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertMessage();
            });
      }
     */


    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding:
          EdgeInsets.only(top: MediaQuery.of(context).size.height / 10),
          child: Text(
            'Gå live',
            style: TextStyle(
                color: Colors.greenAccent,
                fontSize: MediaQuery.of(context).size.height / 18),
          ),
        ),
        Text(
          'Starta din egna radiokanal',
          style:
          TextStyle(fontSize: MediaQuery.of(context).size.height / 25),
        ),
        Padding(
          padding:
          EdgeInsets.only(top: MediaQuery.of(context).size.height / 60),
          child: Text(
            'Kommentera matcher, diskutera problem, sänd nyheter, läs böcker eller sänd musik.',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height / 40,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 18,
              bottom: MediaQuery.of(context).size.height / 40),
          child: Text(
            'Välj',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 30),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.1,
          child: GradientElevatedButton.icon(
            onPressed: () {
              Provider.of<NavVM>(context, listen: false).pushView(constants.goLive2);
            },
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.greenAccent,
                  Colors.blueAccent,
                ]),
            icon: const Icon(Icons.mic),
            label: const Text(
              'Gå live med endast ljud',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
