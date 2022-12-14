import 'package:cmt_projekt/models/navigation_model.dart';
import 'package:cmt_projekt/widgets/comment_app_bar.dart';
import 'package:cmt_projekt/widgets/comment_nav_bar.dart';
import 'package:cmt_projekt/models/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmt_projekt/view_models/navigation_vm.dart';


/// MainViewNavigator ///
/// Creates TabNavigators and puts them in a stack. Each TabNavigator gets
/// a NavKey, TabId and routing data from NavVM/NavigationModel
class MainViewNavigator extends StatefulWidget {
  const MainViewNavigator({Key? key}) : super(key: key);

  @override
  State<MainViewNavigator> createState() => _MainViewNavigatorState();
}

class _MainViewNavigatorState extends State<MainViewNavigator> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Provider.of<NavVM>(context).onWillPop(),
        child: Scaffold(
          appBar: CommentAppBar(),
          body: Stack(
            children: <Widget>[
              _buildOffstageNavigator(TabId.home),
              _buildOffstageNavigator(TabId.live),
            ],
          ),
          bottomNavigationBar: const CommentNavBar(),
        )
    );
  }

  Widget _buildOffstageNavigator(TabId tabId) {
    return Offstage(
      offstage: Provider.of<NavVM>(context).currentTab != tabId,
        child: TabNavigator (
          navigatorKey: Provider.of<NavVM>(context).navKeys[tabId]!,
          tabId: tabId,
          routingData: Provider.of<NavVM>(context).routingData[tabId]!,
        )
    );
  }
}
