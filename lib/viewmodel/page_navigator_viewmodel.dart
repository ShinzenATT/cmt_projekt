import 'package:cmt_projekt/app/View/app_channelpage.dart';
import 'package:cmt_projekt/app/View/app_createaccountpage.dart';
import 'package:cmt_projekt/app/View/app_demo.dart';
import 'package:cmt_projekt/app/View/app_golive.dart';
import 'package:cmt_projekt/app/View/app_homepage.dart';
import 'package:cmt_projekt/app/View/app_loginpage.dart';
import 'package:cmt_projekt/app/View/app_meny.dart';
import 'package:cmt_projekt/app/View/app_welcomepage.dart';
import 'package:cmt_projekt/website/View/web_homepage.dart';
import 'package:cmt_projekt/website/View/web_loginpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants.dart' as constant;

class PageNavigator {
  final Map _routes = <String, WidgetBuilder>{
    constant.home: (BuildContext context) =>
        kIsWeb ? const WebHomePage() : const AppHomePage(),
    constant.createAcc: (BuildContext context) => const AppCreateAccountPage(),
    constant.demo: (BuildContext context) => StreamLoop(),
    constant.login: (BuildContext context) =>
        kIsWeb ? const WebLoginPage() : const AppLoginPage(),
    constant.appChannel: (BuildContext context) => AppChannelPage(),
    constant.appMenu: (BuildContext context) => const AppMenu(),
    constant.appWelcome: (BuildContext context) => const AppWelcomePage(),
    constant.goLive: (BuildContext context) => const AppGoLive(),
    constant.goLive2: (BuildContext context) => const AppGoLive2(),
  };

  get routes => _routes;
}
