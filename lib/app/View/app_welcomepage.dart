
import 'package:cmt_projekt/viewmodel/vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/src/provider.dart';

import '../../constants.dart' as constant;

///First version of welcomepage for the app.

class AppWelcomePage extends StatelessWidget {
  const AppWelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.greenAccent,
            Colors.blueAccent,
          ],
        )),
        padding: const EdgeInsets.all(30),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Text(
                    context.read<VM>().title.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text(
                  'Din moderna radioapp',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 10,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35.0),
                              side: const BorderSide(
                                  color: Colors.white, width: 3))),
                      onPressed: () {
                        Navigator.of(context).pushNamed(constant.createAccount);
                      },
                      child: const Text(
                        'Skapa konto',
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 10,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35.0),
                            side: const BorderSide(
                                color: Colors.white, width: 3))),
                    onPressed: () {
                      Navigator.of(context).pushNamed(constant.login);
                    },
                    child: const Text(
                      'Logga in',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
