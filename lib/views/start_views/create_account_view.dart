import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:cmt_projekt/widgets/comment_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_ui_widgets/gradient_ui_widgets.dart';
import 'package:provider/provider.dart';

///First version of the CreateAcountPage for the website.
class CreateAccountView extends StatelessWidget {
  const CreateAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    MainVM mainVM = Provider.of<MainVM>(context);

    return Scaffold(
      appBar: CommentAppBar(),
      body: Container(
        padding: const EdgeInsets.all(30),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
                onChanged: (String value) => mainVM.newUserData.eMail,
                textInputAction: TextInputAction.next, // Moves focus to next textfield.
                decoration: const InputDecoration(
                  labelText: 'Epost',
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                onChanged: (String value) => mainVM.newUserData.userName,
                textInputAction: TextInputAction.next, // Moves focus to next textfield.
                decoration: const InputDecoration(
                  labelText: 'Användarnamn',
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                onChanged: (String value) => mainVM.newUserData.phoneNr,
                textInputAction: TextInputAction.next, // Moves focus to next textfield.
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Telefonnummer',
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: TextFormField(
                onChanged: (String value) => mainVM.newUserData.password,
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
                onChanged: (String value) => mainVM.newUserData.password2,
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
                      mainVM.comparePw(context);
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