import 'package:cmt_projekt/viewmodel/vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppMenu extends StatelessWidget {
  const AppMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height / 3),
        child: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                context.read<VM>().title.toUpperCase(),
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Din moderna radioapp',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height / 3),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Text(
                              'Redigera',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.account_circle_outlined,
                    size: 70,
                    color: Colors.white,
                  ),
                  Text(
                    context.read<VM>().getEmail() ?? 'Gäst',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
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
          padding: const EdgeInsets.only(top: 20, left: 10),
          children: [
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
                context.read<VM>().profileInformation(context);
              },
            ),
            ListTile(
              title: const Text('Appinställningar'),
              onTap: () {
                // Update the state of the app.
                // ...
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
              },
            ),
            ListTile(
              title: const Text('Min kanal'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Streaming intällningar'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Saldo'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Prenumerationer & följare'),
              onTap: () {
                // Update the state of the app.
                // ...
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
              },
            ),
            ListTile(
              title: const Text('Vanliga frågor'),
              onTap: () {
                // Update the state of the app.
                // ...
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
                context.read<VM>().logOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
