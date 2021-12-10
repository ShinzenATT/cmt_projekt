import 'package:cmt_projekt/viewmodel/homepageviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class AppMenu extends StatelessWidget {
  const AppMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Column(
            children: const [
              Text('COMMENT'),
            ],
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                  Colors.black,
                  Colors.blueAccent,
                ])),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.only(top: 40),
          children: [
            ListTile(
              title: const Text('Inställningar'),
              onTap: () {
                // Update the state of the app.
                // ...

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Kontakta oss'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Om'),
              onTap: () {
                // Update the state of the app.
                // ...
                showAboutDialog(context: context);
              },
            ),
            ListTile(
              title: const Text('Logga ut'),
              onTap: () {
                // Update the state of the app.
                // ...
                context.read<HomePageViewModel>().logOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
