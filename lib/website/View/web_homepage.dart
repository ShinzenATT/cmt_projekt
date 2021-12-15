import 'package:cmt_projekt/viewmodel/vm.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/provider.dart';

///Homepage för hemsidan.
class WebHomePage extends StatefulWidget {
  const WebHomePage({Key? key}) : super(key: key);

  @override
  _WebHomePageState createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          ///Färgtemat för appbaren på startsidan.
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                Colors.greenAccent,
                Colors.blueAccent,
              ])),
        ),

        ///En textknapp med texten COMMENT, har i dagsläget ingen funktion men tanken
        /// är att man ska hamna längst upp på startsidan igen.
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {},
              child: const Text(
                'COMMENT',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),

      ///Knapp för demosidan, har i dagsläget ingen funktion. Knappen ska inte
      ///finnas kvar permanent.
      body: Center(
        child: SizedBox(
          width: 200,
          height: 50,
          child: GradientElevatedButton(
            child: const Text(
              'Demo Sida',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {},
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

      ///Menyn i appbaren på hemsidan.
      ///Innehåller en header som innehåller en text samt användarens email.
      ///Innehåller också en lista med olika textknappar som tar användaren till bla profilinformation.
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Colors.blueAccent,
                    Colors.greenAccent,
                  ])),
              child: Column(
                children: [
                  const Text(
                    'HEJ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    context.read<VM>().getEmail() ?? 'Gäst',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Allmänt',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              title: const Text('Kontoinställningar'),
              onTap: () {
                // Update the state of the app.
                // ...
                context.read<VM>().channelSettings(context);
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
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Mitt konto',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
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
                // Navigator.pop(context);
                context.read<VM>().profileInformation(context);
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
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Hjälplcenter',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
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
                context.read<VM>().logOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
