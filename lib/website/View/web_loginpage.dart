import 'package:cmt_projekt/viewmodel/loginpageviewmodel.dart';
import 'package:cmt_projekt/website/View/web_createaccountwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

import '../../constants.dart' as constant;


///First version of loginpage for the website.

class WebLoginPage extends StatelessWidget {
  const WebLoginPage({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.read<LoginPageViewModel>().title,
                style:
                    const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          FittedBox(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  elevation: 3,
                  child: Container(
                    //Här kan ni ta
                    padding: const EdgeInsets.all(30),
                    width: 500,
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
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            TextFormField(
                              controller:
                                  context.watch<LoginPageViewModel>().login,
                              decoration: const InputDecoration(
                                labelText: 'E-post eller telefonnummer',
                              ),
                            ),
                            TextFormField(
                              controller:
                                  context.watch<LoginPageViewModel>().password,
                              decoration: InputDecoration(
                                labelText: 'Lösenord',
                                suffixIcon: IconButton(
                                  hoverColor: Colors.transparent,
                                  splashRadius: null,
                                  splashColor: Colors.transparent,
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    context
                                            .watch<LoginPageViewModel>()
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
                                onPressed: () {},
                                child: const Text('Glömt lösenord?'),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<LoginPageViewModel>()
                                    .changePage(context, constant.home);
                              },
                              child: const Text('Logga in'),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text(
                                'Gästläge',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return WebCreateAccountWidget();
                                    });
                              },
                              child:
                                  const Text('Inget konto? Registrera dig här'),
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
    );
  }
}
