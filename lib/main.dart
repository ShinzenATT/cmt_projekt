import 'package:cmt_projekt/apis/prefs.dart';
import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:cmt_projekt/view_models/navigation_vm.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:cmt_projekt/views/main_view_navigator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs();
  await Prefs().setUp(); // instancing the Prefs singleton
  runApp(
    MultiProvider(
      // registers the view models
      providers: [
        ChangeNotifierProvider(create: (_) => MainVM()),
        ChangeNotifierProvider(create: (context) => NavVM(context)),
        ChangeNotifierProvider(create: (_) => StreamVM()),
      ],
      child: const MyApp(),
    ),
  );
}

/// The main class that the is mounted to, it's instanced in main
class MyApp extends StatelessWidget {
  /// const constructor for [MyApp]
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Comment - Radio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const MainViewNavigator(), // We immediately route to our own MainNavigatorView
    );
  }
}