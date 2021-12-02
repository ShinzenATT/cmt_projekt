import 'package:cmt_projekt/app/View/app_createaccountpage.dart';
import 'package:cmt_projekt/app/View/app_homepage.dart';
import 'package:cmt_projekt/viewmodel/loginpageviewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/src/provider.dart';

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
          elevation: 0,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                context.read<LoginPageViewModel>().title,
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
      body: SingleChildScrollView(
        child: Container(
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
                  const Text('Vänligen ange dina inloggningsuppgifter'),
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
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 10,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Colors.black, width: 3))),
                      onPressed: () {
                        context
                            .read<LoginPageViewModel>()
                            .loginAttempt(context);
                      },
                      child: const Text(
                        'Logga in',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.purple,
                        ),
                      ),
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
                      Text('Välkommen att logga in som '),
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
                              color: Colors.purple,
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
                        Text('Inget konto än? '),
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
                                color: Colors.purple,
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
      ),
    );
  }
}
