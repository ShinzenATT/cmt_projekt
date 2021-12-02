import 'package:cmt_projekt/app/View/app_welcomepage.dart';
import 'package:cmt_projekt/viewmodel/createaccviewmodel.dart';
import 'package:cmt_projekt/viewmodel/loginpageviewmodel.dart';
import 'package:cmt_projekt/viewmodel/page_navigator_viewmodel.dart';
import 'package:cmt_projekt/viewmodel/stream_view_model.dart';
import 'package:cmt_projekt/website/View/web_loginpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginPageViewModel()),
      ChangeNotifierProvider(create: (_) => CreateAccountViewModel()),
      ChangeNotifierProvider(create: (_) => StreamViewModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: kIsWeb ? const WebLoginPage() : AppWelcomePage(),
      routes: PageNavigator().routes,
    );
  }
}