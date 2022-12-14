import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../views/main_navigator_view.dart';
import '../views/start_views/create_account_view.dart';
import '../views/start_views/login_view.dart';
import '../views/start_views/welcome_view.dart';
import '../models/nav_key_model.dart';
import 'main_vm.dart';
import 'package:cmt_projekt/constants.dart' as constants;


/// An enum for the different tabs of the NavigationBar, because it's simply
/// easier to remember what is what.
enum TabId { search , home , live }


/// The NavigationViewModel is used to deliver, modify and perform operations
/// on all data concerning the apps navigation, and the building of widgets
/// that are sensitive to that data. Its purpose is to take care of everything
/// that is unnecessary for the views to do.
class NavVM with ChangeNotifier{

  final _navKeys = {
    TabId.search: GlobalKey<NavigatorState>(),
    TabId.home:   GlobalKey<NavigatorState>(),
    TabId.live:   GlobalKey<NavigatorState>(),
  };

  TabId _currentTab = TabId.home;

  void selectTab(TabId tabId) {
    if(tabId == currentTab) {
      _navKeys[tabId]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      _currentTab = tabId;
    }
    notifyListeners();
  }

  get navKeys => _navKeys;

  get currentTab => _currentTab;
  get currentTabIndex { switch (currentTab) {
                          case TabId.search: return 0;
                          case TabId.home:   return 1;
                          case TabId.live:   return 2; }
  }

  Future<bool> onWillPop() async {
    final isFirstRouteInCurrentTab =
            !await _navKeys[_currentTab]!.currentState!.maybePop();
    if (isFirstRouteInCurrentTab) {
      if (_currentTab != TabId.home) {
        selectTab(TabId.home);
        return false;
      }
    }
    return isFirstRouteInCurrentTab;
  }







  /// MainNavigatorView data & methods ///
  // The MainNavigatorView works slightly different from the other Navigators.
  // It uses a IndexedStack and this is keeping track of the current and
  // previous Index. This allows for the state of the views in each tab of the
  // BottomNavigationBar to be kept intact while navigating in the other tabs.
  // MainNavigatorView's current & previous Index.

  /// Setter for mainIndex ///
  // Variable used by the BottomNavigationBar.
  void setMainIndex(int newIndex) {
    if (newIndex == mainIndex) {
      switch (newIndex) {
        case 1:
          _homeNavKey.resetTo(constants.channels);
          break;
        case 2:
          _goLiveNavKey.resetTo(constants.goLive);
          break;
      }
    }
    if (newIndex == 0) { return; }                 /* TODO: Implementera sök-sida. */
    previousMainIndex = mainIndex;
    mainIndex = newIndex;
    notifyListeners();
  }


  int previousMainIndex = 1;
  int mainIndex = 1;


  /// Decides initial route ///
  String initialRoute(context) => checkSignedIn(context) ? constants.mainApp : constants.welcome;

  /// isSignedIn && get context helpers //
  // For knowing if the user is signed in (Logged in OR as a Guest).
  bool signedIn = false;
  bool checkSignedIn(context) {
    signedIn = Provider.of<MainVM>(context, listen: false).user.isSignedIn;
    return signedIn;
  }

  /// Push initialRoute! ///
  void pushInitialRoute(context) {
    _appNavKey.navigateTo(initialRoute(context));
    debugPrint("void pushInitialRoute(context)- DONE!");
  }

  /// PushView navigator function ///
  /// It is supposed to be the only push you need, it automatically
  /// knows which NavKey should be used through 'activeNavKey' below.
  void pushView(route) {
  activeNavKey.navigateTo(route);
  notifyListeners();
  }

  /// Navigate back by popping ///
  // For popping to previous route of the currently active navigator but it
  // also makes sure that the streaming channel gets closed down when the
  // BackButton is pressed.
  void goBack(context) {
    StreamVM streamVM = Provider.of<StreamVM>(context, listen: false);
    if(mainIndex == 2 && streamVM.streamModel.isInitiated) {
      streamVM.closeClient();
    }
    activeNavKey.goBack();
    notifyListeners();
  }

  /// Get active NavKey ///
  // With the help of the 'isSignedIn' & 'mainIndex' variables.
  NavKey get activeNavKey {
    if(signedIn) {
      if(mainIndex == 2) { return _goLiveNavKey; }
      else { return _homeNavKey; }
    } else {
      return _appNavKey;
    }
  }


  /// Can currently active NavKey go back/Pop? ///
  // If it does the AppBar will show a BackButton instead ofthe user icon.
  bool get canPop => activeNavKey.canPop();


  /// NavKey instances with a GlobalKey<NavigatorState> inside ///
  //  These can be reached from anywhere in the app and used to push or pop
  //  different views in the navigator where it is.
  static final NavKey _appNavKey = NavKey('appNavKey');
  static final NavKey _homeNavKey = NavKey('homeNavKey');
  static final NavKey _goLiveNavKey = NavKey('goLiveNavKey');
  get appNavKey => _appNavKey.getKey;
  get homeNavKey => _homeNavKey.getKey;
  get goLiveNavKey => _goLiveNavKey.getKey;



  /// Reset navigation! ///
  // (when logging out).
  void reset() {
    previousMainIndex = 1;
    mainIndex = 1;
    signedIn = false;
    _homeNavKey.resetTo(constants.channels);
    _goLiveNavKey.resetTo(constants.goLive);
    _appNavKey.resetTo(constants.welcome);
    notifyListeners();
  }



}