import 'package:flutter/material.dart';
import 'navigation_model.dart';


/// Tab Navigator ///
// See NavigationModel for the routing data that is used to build the
// different navigators.
class TabNavigator extends StatelessWidget {
  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.routingData,
    required this.tabId}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final Map<String, Widget> routingData;
  final TabId tabId;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => routingData[settings.name] ?? routingData.values.first,
        );
      },
    );
  }
}