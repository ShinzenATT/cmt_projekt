import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import '../../view_models/navigation_vm.dart';
import 'package:cmt_projekt/constants.dart' as constants;

/// The LoginView ///
class LoginView extends StatelessWidget {
  /// A const constructor for [LoginView]
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // "Shortcuts" to access the providers later in the code
    MainVM mainVM = Provider.of<MainVM>(context, listen: true);
    NavVM navVM = Provider.of<NavVM>(context, listen: false);

    /// FormState key and variables to handle the user input
    final _signInFormKey = GlobalKey<FormState>();
    String? password;
    String? login;

    return Container(
        padding: const EdgeInsets.all(30),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Form(
          key: _signInFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //All children are wrapped in flexible to adjust when keyboard is used
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  //All children are wrapped in flexible to adjust when keyboard is used
                  children: [
                    const Flexible(
                      flex: 2,
                      child: Text(
                        'Välkommen',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Flexible(
                      flex: 1,
                      child: Text(
                        'Vänligen ange dina inloggningsuppgifter',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 40,
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        onSaved: (value) => login = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Du måste ange E-post eller telefonnummer';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next, // Moves focus to next text field.
                        decoration: const InputDecoration(
                          labelText: 'E-post eller telefonnummer',
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: TextFormField(
                        onSaved: (value) => password = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Du måste ange lösenord';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done, // Close keyboard.
                        decoration: InputDecoration(
                          labelText: 'Lösenord',
                          suffixIcon: IconButton(
                            hoverColor: Colors.transparent,
                            splashRadius: null,
                            splashColor: Colors.transparent,
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              mainVM.showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              mainVM.toggleShowPassword();
                            },
                          ),
                        ),
                        obscureText: !mainVM.showPassword,
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          onPressed: () {}, // TODO: Implement password reset
                          child: const Text('Glömt ditt lösenord?'),
                        ),
                      ),
                    ),
                    const Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 30,
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: SizedBox(
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
                            if(_signInFormKey.currentState!.validate()) {
                              _signInFormKey.currentState!.save();
                              mainVM.loginAttempt(context, login, password);
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
              Flexible(
                flex: 1,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Row(
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
                              mainVM.guestSign(context);
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
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
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
                                navVM.pushView(constants.createAccount);
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
