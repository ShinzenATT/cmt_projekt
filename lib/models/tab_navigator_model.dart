import 'package:flutter/material.dart';
import 'navigation_model.dart';


/// ## Tab Navigator
/// See [NavigationModel] for the routing data that is used to build the
/// different navigators.
class TabNavigator extends StatelessWidget {
  /// A const constructor for [TabNavigator] which also initialises navigation objects
  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.routingData,
    required this.tabId
  }) : super(key: key);

  /// The keys for bottom navigation, see [NavigationModel.navKeys]
  final GlobalKey<NavigatorState> navigatorKey;
  /// The widgets to route to on navigation events, see [NavigationModel.routingData]
  final Map<String, Widget> routingData;
  /// The id of the current tab
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
