import 'package:cmt_projekt/viewmodel/homepageviewmodel.dart';
import 'package:flutter/material.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/src/provider.dart';

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
                Colors.black,
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
                  Colors.black,
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
                    Colors.black,
                    Colors.blueAccent,
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
                    context.read<HomePageViewModel>().getEmail() ?? 'Gäst',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('Profil information'),
              onTap: () {
                Navigator.pop(context);
                context.read<HomePageViewModel>().profileInformation(context);
              },
            ),
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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
