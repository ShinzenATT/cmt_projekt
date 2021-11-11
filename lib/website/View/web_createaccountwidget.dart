import 'package:cmt_projekt/viewmodel/createaccviewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

///First version of the CreateAcountPage for the website.

class WebCreateAccountWidget extends StatelessWidget {
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
                controller: context.watch<CreateAccountViewModel>().email,
                decoration: const InputDecoration(
                  labelText: 'Epost',
                ),
              ),
              TextFormField(
                controller: context.watch<CreateAccountViewModel>().phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Telefonnummer',
                ),
              ),
              TextFormField(
                controller: context.watch<CreateAccountViewModel>().password1,
                obscureText:
                    !context.watch<CreateAccountViewModel>().accountPassword,
                decoration: const InputDecoration(
                  labelText: 'Lösenord',
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
              TextFormField(
                controller: context.watch<CreateAccountViewModel>().password2,
                obscureText:
                    !context.watch<CreateAccountViewModel>().accountPassword,
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
                    value:
                        context.watch<CreateAccountViewModel>().accountPassword,
                    onChanged: (_) {
                      context
                          .read<CreateAccountViewModel>()
                          .changePasswordVisibility();
                    },
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onTap: () {
                      context
                          .read<CreateAccountViewModel>()
                          .changePasswordVisibility();
                    },
                    child: const Text("Visa lösenord"),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<CreateAccountViewModel>().comparePw(context);
                },
                child: const Text("Skapa Konto"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
