import 'package:cmt_projekt/api/navigation_handler.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/viewmodel/main_vm.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/provider.dart';

import '../../widgets/comment_app_bar.dart';

class AppGoLive extends StatelessWidget {
  const AppGoLive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: context.read<MainViewModel>().willPopCallback,
      child: Scaffold(
        appBar: CommentAppBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.center,
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
                  Navigator.pushReplacementNamed(context, goLive2);
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
            )
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Sök',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.house),
              label: 'Hem',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic_none),
              label: 'Gå live!',
            ),
          ],
          onTap: (value) {
            NaviHandler().setContext(context);
            NaviHandler().changePage(value);
          },
          currentIndex: NaviHandler().index,
        ),
      ),
    );
  }
}

class AppGoLive2 extends StatelessWidget {
  const AppGoLive2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: context.read<MainViewModel>().willPopCallback,
      child: Scaffold(
        appBar: CommentAppBar(context),
        body: Column(
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
                future: context.read<MainViewModel>().checkMicPermssion(),
                builder: (context, snapshot) {
                  if (snapshot.data == null || !snapshot.data!) {
                    return GradientElevatedButton.icon(
                      onPressed: () {
                        context.read<MainViewModel>().grantMicPermsission();
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
                    context.read<MainViewModel>().checkMicPermssion().then((value) => {
                          if (value)
                            {context.read<MainViewModel>().channelSettings(context)}
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
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Sök',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.house),
              label: 'Hem',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic_none),
              label: 'Gå live!',
            ),
          ],
          onTap: (value) {
            NaviHandler().setContext(context);
            NaviHandler().changePage(value);
          },
          currentIndex: NaviHandler().index,
        ),
      ),
    );
  }
}
