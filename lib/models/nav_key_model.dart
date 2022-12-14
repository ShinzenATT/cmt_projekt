import 'package:flutter/material.dart';


/// NavKey model class for creating instances that contains a
/// GlobalKey<NavigatorState> and the necessary methods for it. Used in
/// NavigationVM for navigating the different routes of the app.
class NavKey {

  /// Final variables
  final String? name;
  late final GlobalKey<NavigatorState> navigatorKey;

  /// Constructor
  NavKey(this.name) {
    navigatorKey = GlobalKey<NavigatorState>(debugLabel: name);
  }

  ///Methods & getters
  // Pushes the view associated with the routeName to the Navigator that
  // has the navigatorKey.
  Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> resetTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

  void goBack() { return navigatorKey.currentState!.pop(); }

  bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }

  GlobalKey<NavigatorState> get getKey => navigatorKey;

}