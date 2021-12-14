import 'package:cmt_projekt/viewmodel/createaccviewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/src/provider.dart';

///First version of the CreateAcountPage for the website.

class AppCreateAccountPage extends StatelessWidget {
  const AppCreateAccountPage({Key? key}) : super(key: key);

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
                context.read<CreateAccountViewModel>().title,
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
            const Text(
              "Ange dina uppgifter för att skapa ett konto",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
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
              obscureText: !context
                  .watch<CreateAccountViewModel>()
                  .passwordVisibilityCreate,
              decoration: const InputDecoration(
                labelText: 'Lösenord',
              ),
              keyboardType: TextInputType.visiblePassword,
            ),
            TextFormField(
              controller: context.watch<CreateAccountViewModel>().password2,
              obscureText: !context
                  .watch<CreateAccountViewModel>()
                  .passwordVisibilityCreate,
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
                  value: context
                      .watch<CreateAccountViewModel>()
                      .passwordVisibilityCreate,
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
                  context.read<CreateAccountViewModel>().comparePw(context);
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
      ),
    );
  }
}
