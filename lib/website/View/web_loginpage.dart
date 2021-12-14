import 'package:cmt_projekt/viewmodel/loginpageviewmodel.dart';
import 'package:cmt_projekt/website/View/web_createaccountwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';

import '../../constants.dart' as constant;

///Loginpage för hemsidan.

class WebLoginPage extends StatelessWidget {
  const WebLoginPage({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        ///Här sätts färgtemat för bakgrunden på loginpage.
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
              Colors.blueAccent,
              Colors.greenAccent,
              Colors.greenAccent,
            ])),

        ///Rad som innehåller applikationens titel samt undertext till vänster och
        ///ett kort med olika alternativ för att logga in, skapa konto osv till vänster.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Positioned(
                      top: 3,
                      left: 3,
                      child: Text(
                        context.read<LoginPageViewModel>().title.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      context.read<LoginPageViewModel>().title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Din moderna liveradio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            FittedBox(
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 20,
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      width: 550,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Välkommen',
                                style: TextStyle(
                                    fontSize: 50, fontWeight: FontWeight.bold),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 40),
                                child: Text(
                                  'Vänligen ange dina inloggningsuppgifter',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller:
                                    context.watch<LoginPageViewModel>().login,
                                decoration: const InputDecoration(
                                  labelText: 'E-post eller telefonnummer',
                                ),
                              ),
                              TextFormField(
                                controller: context
                                    .watch<LoginPageViewModel>()
                                    .password,
                                decoration: InputDecoration(
                                  labelText: 'Lösenord',
                                  suffixIcon: IconButton(
                                    hoverColor: Colors.transparent,
                                    splashRadius: null,
                                    splashColor: Colors.transparent,
                                    icon: Icon(
                                      /// Ikonen ändras beroende på om man valt att se lösenord eller inte.
                                      context
                                              .watch<LoginPageViewModel>()
                                              .passwordVisibilityLogin
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      /// Updaterar en bool ifall man vill se lösenord eller inte.
                                      context
                                          .read<LoginPageViewModel>()
                                          .changePasswordVisibility();
                                    },
                                  ),
                                ),
                                obscureText: !context
                                    .watch<LoginPageViewModel>()
                                    .passwordVisibilityLogin,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Glömt lösenord?',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 200,
                                height: 50,
                                child: GradientElevatedButton(
                                  child: const Text(
                                    'Logga in',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    context
                                        .read<LoginPageViewModel>()
                                        .loginAttempt(context);
                                  },
                                  gradient: const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.blueAccent,
                                        Colors.greenAccent,
                                      ]),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Inget konto än? ',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return WebCreateAccountWidget();
                                            });
                                      },
                                      child: const Text(
                                        "Registrera dig här",
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Välkommen att logga in som ',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    onTap: () {
                                      context
                                          .read<LoginPageViewModel>()
                                          .changePage(context, constant.home);
                                    },
                                    child: const Text(
                                      "gäst",
                                      style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
