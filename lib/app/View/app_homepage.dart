import 'dart:async';
import 'dart:typed_data';

import 'package:cmt_projekt/api/navigation_handler.dart';
import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/viewmodel/loginpageviewmodel.dart';
import 'package:cmt_projekt/viewmodel/stream_view_model.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/src/provider.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({Key? key}) : super(key: key);

  @override
  _AppHomePageState createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(appMenu);
              },
              icon: const Icon(Icons.account_circle_outlined),
            ),
          ),
          /* actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(appChannel);
                  Prefs().storedData.setString("intent", "h");
                  context.read<StreamViewModel>().startup(context);
                },
                icon: const Icon(Icons.mic_none),
                iconSize: 30,
              ),
            )
          ], */
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Colors.greenAccent,
                  Colors.blueAccent,
                ])),
          ),
          elevation: 0,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                context.read<LoginPageViewModel>().title.toUpperCase(),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Din moderna radioapp',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 50,
          child: GradientElevatedButton(
            child: const Text(
              'DEMO',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(demo);
            },
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.greenAccent,
                  Colors.blueAccent,
                ]),
          ),
        ),
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
          setState(() {
            NaviHandler().setContext(context);
            NaviHandler().changePage(value);
          });
        },
        currentIndex: NaviHandler().index,
      ),
    );
  }
}
