import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

///First version of the CreateAcountPage for the website.

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  bool _passwordVisible = false; //controls the hide-password feature.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          elevation: 5,
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 500,
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("Ange dina uppgifter för att skapa ett konto. "),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Epost',
                  ),
                ),
                TextFormField(
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Telefonnummer',
                  ),
                ),
                TextFormField(
                  obscureText: !_passwordVisible,
                  decoration: const InputDecoration(
                    labelText: 'Lösenord',
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                TextFormField(
                  obscureText: !_passwordVisible,
                  decoration: const InputDecoration(
                    labelText: 'Bekräfta lösenord',
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      splashRadius: 0,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      value: _passwordVisible,
                      onChanged: (value) {
                        setState(() {
                          _passwordVisible = value!;
                        });
                      },
                    ),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                      child: const Text("Visa lösenord"),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Skapa Konto"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
