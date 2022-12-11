import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/provider.dart';

///First version of the CreateAcountPage for the website.

class AppCreateAccountPage extends StatelessWidget {
  const AppCreateAccountPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
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
                context.read<MainViewModel>().title,
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
          children: [//All children are wrapped in Flexible to adjust when the keyboard is used
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
                controller: context.watch<MainViewModel>().email,
                textInputAction: TextInputAction.next, // Moves focus to next textfield.
                decoration: const InputDecoration(
                  labelText: 'Epost',
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                controller: context.watch<MainViewModel>().username,
                textInputAction: TextInputAction.next, // Moves focus to next.
                decoration: const InputDecoration(
                  labelText: 'Användarnamn',
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                controller: context.watch<MainViewModel>().phone,
                textInputAction: TextInputAction.next, // Moves focus to next.
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Telefonnummer',
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                controller: context.watch<MainViewModel>().password1,
                textInputAction: TextInputAction.next, // Moves focus to next.
                obscureText: !context.watch<MainViewModel>().passwordVisibilityCreate,
                decoration: const InputDecoration(
                  labelText: 'Lösenord',
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                controller: context.watch<MainViewModel>().password2,
                textInputAction: TextInputAction.done, // Close keyboard.
                obscureText: !context.watch<MainViewModel>().passwordVisibilityCreate,
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
                      context.read<MainViewModel>().comparePw(context);
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

