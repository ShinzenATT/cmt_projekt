import 'package:cmt_projekt/api/navigation_handler.dart';
import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/app/View/app_homepage.dart';
import 'package:cmt_projekt/app/View/app_welcomepage.dart';
import 'package:cmt_projekt/viewmodel/demo_stream_vm.dart';
import 'package:cmt_projekt/viewmodel/vm.dart';
import 'package:cmt_projekt/viewmodel/page_navigator_vm.dart';
import 'package:cmt_projekt/viewmodel/stream_vm.dart';
import 'package:cmt_projekt/website/View/web_homepage.dart';
import 'package:cmt_projekt/website/View/web_loginpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs();
  NaviHandler();
  await Prefs().setUp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => VM()),
      ChangeNotifierProvider(create: (_) => StreamViewModel()),
      ChangeNotifierProvider(create: (_) => DemoStreamViewModel()),
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
      home: checkLogin(),
      routes: PageNavigator().routes,
    );
  }

  Widget checkLogin() {
    if (Prefs().storedData.getString("email") != null) {
      if (kIsWeb) {
        return const WebHomePage();
      }
      return const AppHomePage();
    }
    if (kIsWeb) {
      return const WebLoginPage();
    }
    return const AppWelcomePage();
  }
}
