import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

import 'views/_import_all_views.dart';


/// All constant data used throughout the project is collected here.

//Page-references
const String home = '/Home';
const String createAcc = '/CreateAccount';
const String demo = '/Demo';
const String hostChannel = '/HostChannel';
const String joinChannel = '/JoinChannel';
const String goLive = '/goLive';
const String goLive2 = '/goLive2';
const String login = '/login';
const String menu = '/AppMenu';
const String welcome = '/AppWelcome';

//The routing map data given to MyApp in main
final Map<String, WidgetBuilder> routingData = <String, WidgetBuilder>{
  home: (BuildContext context) => const AppHomePage(),
  createAcc: (BuildContext context) => const AppCreateAccountPage(),
  login: (BuildContext context) => const AppLoginPage(),
  hostChannel: (BuildContext context) => const AppHostPage(),
  joinChannel: (BuildContext context) => const AppListenPage(),
  menu: (BuildContext context) => const AppMenu(),
  welcome: (BuildContext context) => const AppWelcomePage(),
  goLive: (BuildContext context) => const AppGoLive(),
  goLive2: (BuildContext context) => const AppGoLive2(),
};

//dbLogic
const String dbLogin = "0";
const String dbAccount = "1";
const String dbGetInfo = "2";
const String dbCreateChannel = "3";
const String dbChannelOffline = "4";
const String dbGetOnlineChannels = "5";
const String dbPing = "6";
const String dbAddViewers = "7";
const String dbDelViewers = "8";
const String dbDelViewer = "9";

final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0
  )
);