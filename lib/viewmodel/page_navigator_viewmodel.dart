import 'package:cmt_projekt/app/View/app_homepage.dart';
import 'package:cmt_projekt/website/View/web_homepage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PageNavigator {
  final Map _routes = <String, WidgetBuilder>{
    '/Home': (BuildContext context) =>
        kIsWeb ? const WebHomePage() : const AppHomePage(),
  };

  get routes => _routes;
}
