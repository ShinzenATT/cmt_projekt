import 'package:cmt_projekt/apis/navigation_handler.dart';
import 'package:cmt_projekt/apis/prefs.dart';
import 'package:cmt_projekt/views/home_view.dart';
import 'package:cmt_projekt/views/welcome_view.dart';
import 'package:cmt_projekt/--Bin%20(Deprecated)/demo_stream_vm.dart';
import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'constantsflutter.dart' as constant;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs();
  NaviHandler();
  await Prefs().setUp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => MainViewModel()),
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
      routes: constant.routingData,
    );
  }

  Widget checkLogin() {
    if (Prefs().storedData.getString("email") != null) {
      return const AppHomePage();
    }
    return const AppWelcomePage();
  }
}
