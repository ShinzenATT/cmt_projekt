import 'package:cmt_projekt/widgets/comment_nav_bar.dart';
import 'package:cmt_projekt/models/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmt_projekt/view_models/navigation_vm.dart';


class MainNavigatorView extends StatefulWidget {
  const MainNavigatorView({Key? key}) : super(key: key);

  @override
  State<MainNavigatorView> createState() => _MainNavigatorViewState();
}

class _MainNavigatorViewState extends State<MainNavigatorView> {



  @override
  Widget build(BuildContext context) {

    NavVM navVM =Provider.of<NavVM>(context);

    return WillPopScope(
        onWillPop: () => Provider.of<NavVM>(context).onWillPop(),
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              _buildOffstageNavigator(TabId.search),
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
          navigatorKey: Provider.of<NavVM>(context).navKeys[tabId],
          tabId: tabId,
        )
    );
  }
}
