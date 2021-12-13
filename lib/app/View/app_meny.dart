import 'package:cmt_projekt/viewmodel/homepageviewmodel.dart';
import 'package:cmt_projekt/viewmodel/loginpageviewmodel.dart';
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
        ),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: const EdgeInsets.only(top: 40, left: 10),
          children: [
            Center(
              child: Text(
                context.read<HomePageViewModel>().getEmail() ?? 'Gäst',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const Text(
              'Allmänt',
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            ListTile(
              title: const Text('Kontoinställningar'),
              onTap: () {
                // Update the state of the app.
                // ...

                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Appinställningar'),
              onTap: () {
                // Update the state of the app.
                // ...

                Navigator.pop(context);
              },
            ),
            const Text(
              'Mitt konto',
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            ListTile(
              title: const Text('Kanalutseende'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Min kanal'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Streaming intällningar'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Saldo'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Prenumerationer & följare'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
            const Text(
              'Hjälplcenter',
              style: TextStyle(
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
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
              title: const Text('Vanliga frågor'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text(
                'Logga ut',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                context.read<HomePageViewModel>().logOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
