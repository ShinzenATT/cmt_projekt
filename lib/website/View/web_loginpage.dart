
import 'package:cmt_projekt/viewmodel/main_vm.dart';
import 'package:cmt_projekt/website/View/web_createaccountwidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';

import '../../constants.dart' as constant;

///Login page for the website.
class WebLoginPage extends StatelessWidget {
  const WebLoginPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        ///Here the color theme for the background is set for the login page.
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
              Colors.blueAccent,
              Colors.greenAccent,
              Colors.greenAccent,
            ])),

        ///Line containing the application title and subtitle on the left and
        ///a card with various options for logging in, creating an account, etc. to the left.
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
                        context.read<MainViewModel>().title.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      context.read<MainViewModel>().title.toUpperCase(),
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
                                    context.watch<MainViewModel>().login,
                                decoration: const InputDecoration(
                                  labelText: 'E-post eller telefonnummer',
                                ),
                              ),
                              TextFormField(
                                controller: context
                                    .watch<MainViewModel>()
                                    .password,
                                decoration: InputDecoration(
                                  labelText: 'Lösenord',
                                  suffixIcon: IconButton(
                                    hoverColor: Colors.transparent,
                                    splashRadius: null,
                                    splashColor: Colors.transparent,
                                    icon: Icon(
                                      ///The icon changes depending on whether you have chosen to see the password or not.
                                      context
                                              .watch<MainViewModel>()
                                              .passwordVisibilityLogin
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      ///Updates a bool if you want to see the password or not.
                                      context
                                          .read<MainViewModel>()
                                          .changePasswordVisibilityLogin();
                                    },
                                  ),
                                ),
                                obscureText: !context
                                    .watch<MainViewModel>()
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
                                        .read<MainViewModel>()
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
                                              return const WebCreateAccountWidget();
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
                                          .read<MainViewModel>()
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
