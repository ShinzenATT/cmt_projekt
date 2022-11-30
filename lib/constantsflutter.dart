import 'package:flutter/cupertino.dart';
import 'views/_import_all_views.dart';
import 'constants.dart';

/// All constant data used throughout the project is collected here and in constants.dart.

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