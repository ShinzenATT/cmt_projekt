import 'package:cmt_projekt/viewmodel/main_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/provider.dart';

///CreateAccountPage for the website, it's created in a showdialog in Loginpage.

class WebCreateAccountWidget extends StatelessWidget {
  const WebCreateAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
                controller: context.watch<MainViewModel>().email,
                decoration: const InputDecoration(
                  labelText: 'Epost',
                ),
              ),
              TextFormField(
                controller: context.watch<MainViewModel>().username,
                decoration: const InputDecoration(
                  labelText: 'Användarnamn',
                ),
              ),
              TextFormField(
                controller: context.watch<MainViewModel>().phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Telefonnummer',
                ),
              ),
              TextFormField(
                controller: context.watch<MainViewModel>().password1,
                obscureText: !context.watch<MainViewModel>().passwordVisibilityCreate,
                decoration: const InputDecoration(
                  labelText: 'Lösenord',
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
              TextFormField(
                controller: context.watch<MainViewModel>().password2,
                obscureText: !context.watch<MainViewModel>().passwordVisibilityCreate,
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
                    value: context.watch<MainViewModel>().passwordVisibilityCreate,
                    onChanged: (_) {
                      context.read<MainViewModel>().changePasswordVisibilityCreate();
                    },
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () {
                      context.read<MainViewModel>().changePasswordVisibilityCreate();
                    },
                    child: const Text("Visa lösenord"),
                  ),
                ],
              ),
              SizedBox(
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
                    context.read<MainViewModel>().comparePw(context);
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
        ),
      ),
    );
  }
}
