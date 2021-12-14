import 'package:cmt_projekt/viewmodel/loginpageviewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/src/provider.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';

import '../../constants.dart' as constant;

///First version of loginpage for the app.

class AppLoginPage extends StatelessWidget {
  const AppLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
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
      body: Container(
        padding: const EdgeInsets.all(30),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Välkommen',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'Vänligen ange dina inloggningsuppgifter',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  controller: context.watch<LoginPageViewModel>().login,
                  decoration: const InputDecoration(
                    labelText: 'E-post eller telefonnummer',
                  ),
                ),
                TextFormField(
                  controller: context.watch<LoginPageViewModel>().password,
                  decoration: InputDecoration(
                    labelText: 'Lösenord',
                    suffixIcon: IconButton(
                      hoverColor: Colors.transparent,
                      splashRadius: null,
                      splashColor: Colors.transparent,
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        context
                                .read<LoginPageViewModel>()
                                .passwordVisibilityLogin
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
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
                    onPressed: () {
                      /// Implement password reset
                    },
                    child: const Text('Glömt ditt lösenord?'),
                  ),
                ),
                const SizedBox(
                  height: 30,
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
                      context.read<LoginPageViewModel>().loginAttempt(context);
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
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Välkommen att logga in som ',
                      style: TextStyle(fontSize: 16),
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        context.read<LoginPageViewModel>().guestSign(context);
                        context
                            .read<LoginPageViewModel>()
                            .changePage(context, constant.home);
                      },
                      child: const Text(
                        "gäst",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Inget konto än? ',
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
                              .changePage(context, constant.createAccount);
                        },
                        child: const Text(
                          "Registrera dig här",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
