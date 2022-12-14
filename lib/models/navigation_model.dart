import 'package:flutter/cupertino.dart';
import 'package:cmt_projekt/constants.dart' as constants;
import '../views/go_live/go_live_view1.dart';
import '../views/go_live/go_live_view2.dart';
import '../views/go_live/host_channel_view.dart';
import '../views/home_views/channels_view.dart';
import '../views/home_views/listen_channel_view.dart';
import '../views/home_views/menu_view.dart';
import '../views/start_views/login_view.dart';
import '../views/start_views/welcome_view.dart';


/// An enum for the different tabs of the NavigationBar, because it's simply
/// easier to remember what is what.
enum TabId { search , home , live }

/// NavigationModel for all persistent navigation data ///
class NavigationModel {

  /// NavKeys ///
  Map<TabId, GlobalKey<NavigatorState>> get navKeys => _navKeys;

  final Map<TabId, GlobalKey<NavigatorState>> _navKeys = {
    TabId.search: GlobalKey<NavigatorState>(),
    TabId.home:   GlobalKey<NavigatorState>(),
    TabId.live:   GlobalKey<NavigatorState>(),
  };

  /// Routing Data for all view navigators ///
  Map<TabId, Map<String, Widget>> get routingData => _routingData;

  static final Map<TabId, Map<String, Widget>> _routingData =
                                          <TabId, Map<String, Widget>>{
    TabId.live : _goLiveRD,
    TabId.home : _homeRD
  };

  /// Go live view navigator
  static final Map<String, Widget> _goLiveRD = <String, Widget>{
    constants.goLive : const GoLiveView1(),
    constants.goLive2 : const GoLiveView2(),
    constants.hostChannel : const HostChannelView(),
    constants.menu : const MenuView(),
  };

  /// Home view navigator
  static final Map<String, Widget> _homeRD = <String, Widget>{
    constants.channels : const ChannelsView(),
    constants.listenChannel :  const ListenChannelView(),
    constants.menu :  const MenuView(),
  };


  // 'HomeNavigatorView' & 'GoLiveNavigatorView' are built differently and can
  // be found in their respective classes.
  static final Map<String, WidgetBuilder> appRoutingData = <String, WidgetBuilder>{
    //constants.mainApp : (context) => const MainNavigatorView(),
    constants.welcome: (context) => const WelcomeView(),
    constants.login: (context) => const LoginView(),
    //constants.createAccount: (context) => const CreateAccountView(),
  };
}