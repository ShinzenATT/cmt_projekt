import 'package:flutter/cupertino.dart';
import 'package:cmt_projekt/constants.dart' as constants;

import '../views/go_live/go_live_view1.dart';
import '../views/home_views/channels_view.dart';
import '../views/main_navigator_view.dart';
import '../views/start_views/create_account_view.dart';
import '../views/start_views/login_view.dart';
import '../views/start_views/welcome_view.dart';

class NavigationModel {


  /// Routing Data for all view navigators ///

  /// Go live view navigator ///


/*
  static final Map<String, WidgetBuilder> goLiveRoutingData = <String, WidgetBuilder>{
    constants.goLive : (context) => const GoLiveView1();
    constants.goLive2 : (context) => const GoLiveView2();
    constants.hostChannel : (context) => const HostChannelView();
  };

  /// Home view navigator ///
  static final Map<String, WidgetBuilder> homeRoutingData = <String, WidgetBuilder>{
    constants.home : (context) => const ChannelsView(),
    constants.listenChannel : (context) => const ListenChannelView(),
    constants.hostChannel : (context) => const MenuView(),
  };


 */

  /// Routing-data for MyApp in main ///
  // 'HomeNavigatorView' & 'GoLiveNavigatorView' are built differently and can
  // be found in their respective classes.
  static final Map<String, WidgetBuilder> appRoutingData = <String, WidgetBuilder>{
    //constants.mainApp : (context) => const MainNavigatorView(),
    constants.welcome: (context) => const WelcomeView(),
    constants.login: (context) => const LoginView(),
    //constants.createAccount: (context) => const CreateAccountView(),
  };
}