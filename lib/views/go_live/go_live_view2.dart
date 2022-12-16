import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/buttons/gradient_elevated_button.dart';
import 'package:provider/provider.dart';
import 'package:cmt_projekt/view_models/main_vm.dart';
import 'go_live_settings_dialog.dart';

class GoLiveView2 extends StatelessWidget {
  const GoLiveView2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.2),
          child: Text(
            'Innan du börjar',
            style: TextStyle(
                color: Colors.greenAccent,
                fontSize: MediaQuery.of(context).size.height / 18),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              bottom: MediaQuery.of(context).size.height * 0.05,
              top: MediaQuery.of(context).size.height * 0.02),
          child: Text(
            'Måste du först aktivera din mikrofon',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height / 28),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.1,
          child: FutureBuilder<bool>(
            future: context.read<MainVM>().checkMicPermssion(),
            builder: (context, snapshot) {
              if (snapshot.data == null || !snapshot.data!) {
                return GradientElevatedButton.icon(
                  onPressed: () {
                    context.read<MainVM>().grantMicPermsission();
                  },
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.greenAccent,
                        Colors.blueAccent,
                      ]),
                  icon: Icon(
                    Icons.mic,
                    size: MediaQuery.of(context).size.height * 0.07,
                  ),
                  label: const Text(
                    'Aktivera din mikrofon',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                );
              } else {
                return GradientElevatedButton.icon(
                  onPressed: null,
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.greenAccent,
                        Colors.blueAccent,
                      ]),
                  icon: Icon(
                    Icons.check,
                    size: MediaQuery.of(context).size.height * 0.07,
                  ),
                  label: const Text(
                    'Din mikrofon är aktiverad',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                );
              }
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.1,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: Colors.black),
              onPressed: () {
                context.read<MainVM>().checkMicPermssion().then((value) => {
                  if (value) {
                    showDialog(
                    context: context,
                    builder: const GoLiveSettings().build
                    )
                  }
                });
                // context.read<StreamViewModel>().startup(context);
              },
              icon: const Padding(
                padding: EdgeInsets.only(
                  //   right: MediaQuery.of(context).size.width * 0.2,
                  //  left: MediaQuery.of(context).size.width * 0.2
                ),
                child: Text(
                  'Gå vidare',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              label: const Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
