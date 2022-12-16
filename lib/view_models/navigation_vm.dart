import 'package:cmt_projekt/models/navigation_model.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:cmt_projekt/constants.dart' as constants;
import 'package:provider/provider.dart';

import 'main_vm.dart';

/// The NavigationViewModel is used to deliver, modify and perform operations
/// on all data concerning the apps navigation, and the building of widgets
/// that are sensitive to that data. Its purpose is to take care of everything
/// that is unnecessary for the views to do.
class NavVM with ChangeNotifier{

  NavVM(context) { startup(context); }

  /// NavigationModel ///
  // For all persistent navigation data
  static final NavigationModel _navModel = NavigationModel();

  /// Getters ///
  Map<TabId, Map<String, Widget>> get routingData => _navModel.routingData;
  Map<TabId, GlobalKey<NavigatorState>> get navKeys => _navModel.navKeys;
  GlobalKey<NavigatorState> get currentNavKey => navKeys[_currentTab]!;
  TabId get currentTab => _currentTab;


  /// App-wide navigation methods ///

  // Used by the appbar. Set depending on which view gets popped
  bool showAppBar = false;

  /// Can currently active NavKey go back/Pop?
  // If it does the AppBar will show a BackButton instead of the user icon.
  bool get canPop => currentNavKey.currentState!.canPop();

  /// PushView
  // It is supposed to be the only push you need, it automatically
  // knows which NavKey should be used through 'currentNavKey' below.
  void pushView(route) {
    if(route != constants.welcome) { showAppBar = true; }
    currentNavKey.currentState!.pushNamed(route);
    notifyListeners();
  }

  /// Navigate back by popping
  // For popping to previous route of the currently active navigator but it
  // also makes sure that the streaming channel gets closed down when the
  // BackButton is pressed from the hostChannelView.
  void goBack(context) {
    currentNavKey.currentState!.pop();
    if(currentTab == TabId.welcome && !canPop) { showAppBar = false; }
    if(currentTab == TabId.live &&
          Provider.of<StreamVM>(context, listen: false).streamModel.isInitiated) {
      Provider.of<StreamVM>(context, listen: false).closeClient();
    }
    notifyListeners();
  }


  /// MainNavigatorView data & methods ///
  // The MainNavigatorView works slightly different from the other Navigators.
  // It uses a Stack of navigators, one for each stack. This keeps each tab
  // intact while navigating in the other tabs.
  TabId _currentTab = TabId.welcome;

  /// Sets currently active tab
  void selectTab(TabId tabId) {
    if(tabId == TabId.search) { return; }  // TODO: Implement search tab
    if(tabId == _currentTab) {
      navKeys[tabId]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      _currentTab = tabId;
    }
    notifyListeners();
  }

  /// Used to know which NavBar icon to highlight.
  int get currentTabIndex {
    switch (_currentTab) {
      case TabId.search:  return 0;
      case TabId.home:    return 1;
      case TabId.live:    return 2;
      case TabId.welcome: return 1;} // Does not matter cause NavBar is invisible at welcome
  }

  Future<bool> onWillPop() async {
    final isFirstRouteInCurrentTab =
    !await navKeys[_currentTab]!.currentState!.maybePop();
    if (isFirstRouteInCurrentTab) {
      if (_currentTab != TabId.home) {
        selectTab(TabId.home);
        return false;
      }
    }
    return isFirstRouteInCurrentTab;
  }

  void startup(context) {
    if(Provider.of<MainVM>(context, listen: false).isSignedIn) {
      showAppBar = true;
      selectTab(TabId.home);
    }
  }

  /// Logged out ///

  void loggedOut() {
    navKeys[TabId.home]!.currentState!.popUntil((route) => route.isFirst);
    navKeys[TabId.live]!.currentState!.popUntil((route) => route.isFirst);
    navKeys[TabId.welcome]!.currentState!.popUntil((route) => route.isFirst);
    showAppBar = false;
    selectTab(TabId.welcome);
  }


}