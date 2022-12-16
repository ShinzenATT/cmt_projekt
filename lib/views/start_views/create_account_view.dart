import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/provider.dart';

/// The CreateAccountView ///
class CreateAccountView extends StatelessWidget {
  const CreateAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // "Shortcuts" to access the providers later in the code
    MainVM mainVM = Provider.of<MainVM>(context);

    /// FormState key and variables to handle the user input
    final _createAccFormKey = GlobalKey<FormState>();
    String? eMail;
    String? username;
    String? phoneNr;
    String? password;
    String? password2;

    return Container(
      padding: const EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Form(
        key: _createAccFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //All children are wrapped in Flexible to adjust when the keyboard is used
          children: [
            const Flexible(
              flex: 1,
              child: Text(
                "Ange dina uppgifter för att skapa ett konto",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                onSaved: (value) => eMail = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Du måste ange epost';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next, // Moves focus to next textfield.
                decoration: const InputDecoration(
                  labelText: 'Epost',
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                onSaved: (value) => username = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Du måste ange användarnamn';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next, // Moves focus to next textfield.
                decoration: const InputDecoration(
                  labelText: 'Användarnamn',
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                onSaved: (value) => phoneNr = value,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Du måste ange telefonnummer';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next, // Moves focus to next textfield.
                decoration: const InputDecoration(
                  labelText: 'Telefonnummer',
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                onSaved: (value) => password = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Du måste ange lösenord';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next, // Moves focus to next textfield.
                obscureText: !mainVM.showPassword,
                decoration: const InputDecoration(
                  labelText: 'Lösenord',
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                onSaved: (value) => password2 = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Du måste bekräfta lösenord';
                  }
                  return null;
                },
                textInputAction: TextInputAction.done, // Close keyboard.
                obscureText: !mainVM.showPassword,
                decoration: const InputDecoration(
                  labelText: 'Bekräfta lösenord',
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  Checkbox(
                    splashRadius: 0,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    value: mainVM.showPassword,
                    onChanged: (_) {
                      mainVM.toggleShowPassword();
                    },
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () {
                      mainVM.toggleShowPassword();
                    },
                    child: const Text("Visa lösenord"),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: SizedBox(
                width: 200,
                height: 50,
                child: GradientElevatedButton(
                  child: const Text(
                    'Skapa konto',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if(_createAccFormKey.currentState!.validate()) {
                      _createAccFormKey.currentState!.save();
                      mainVM.tryCreateAccount(
                          context, eMail, username, phoneNr, password, password2
                      );
                    }

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
            ),
          ],
        ),
      ),
    );
  }
}