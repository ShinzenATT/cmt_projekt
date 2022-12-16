/// !!! DEPRECATED !!!
/// This class seemed a bit unnecessary since it only contains a final map
/// (and a getter function for said map) and is never changed. The map has
/// instead been added to the file constants.dart
/*

import 'package:cmt_projekt/--Bin%20(Deprecated)/app_demo.dart';

import 'package:cmt_projekt/--Bin (Deprecated)/website/View/web_homepage.dart';
import 'package:cmt_projekt/--Bin (Deprecated)/website/View/web_loginpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart' as constant;



class PageNavigator {
  final Map _routes = <String, WidgetBuilder>{
    constant.home: (BuildContext context) =>
        kIsWeb ? const WebHomePage() : const AppHomePage(),
    constant.createAcc: (BuildContext context) => const AppCreateAccountPage(),
    constant.demo: (BuildContext context) => const StreamLoop(),
    constant.login: (BuildContext context) =>
        kIsWeb ? const WebLoginPage() : const AppLoginPage(),
    constant.hostChannel: (BuildContext context) => const AppHostPage(),
    constant.joinChannel: (BuildContext context) => const AppListenPage(),
    constant.menu: (BuildContext context) => const AppMenu(),
    constant.welcome: (BuildContext context) => const AppWelcomePage(),
    constant.goLive: (BuildContext context) => const AppGoLive(),
    constant.goLive2: (BuildContext context) => const AppGoLive2(),
  };

  get routes => _routes;
}


 */