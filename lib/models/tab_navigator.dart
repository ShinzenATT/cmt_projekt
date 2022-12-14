import 'package:flutter/material.dart';
import '../view_models/navigation_vm.dart';
import 'package:cmt_projekt/constants.dart' as constants;

import '../views/go_live/go_live_view1.dart';
import '../views/go_live/go_live_view2.dart';


/// Tab Navigator ///
///
// See NavigationModel for the routing data that is used to build the
// different navigators.
class TabNavigator extends StatelessWidget {
  // Constructor
  const TabNavigator({ Key? key,
    required this.navigatorKey,
    //required this.routingData,
    required this.tabId}) : super(key: key);

  /// Required final variables
  //final Route<dynamic>? Function(RouteSettings)? routingData;
  final GlobalKey<NavigatorState>? navigatorKey;
  final TabId tabId;

  static final Map<String, WidgetBuilder> appRoutingData = <String, WidgetBuilder>{
    constants.goLive : (context) => const GoLiveView1(),
    constants.goLive2 : (context) => const GoLiveView2(),
  };

  get(s) => appRoutingData[s];

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              settings: settings,
              builder: get(settings.name));
        },
        initialRoute: constants.goLive
    );
  }
}