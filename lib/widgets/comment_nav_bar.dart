import 'package:cmt_projekt/models/navigation_model.dart';
import 'package:cmt_projekt/view_models/navigation_vm.dart';
import 'package:cmt_projekt/views/home_views/menu_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/main_vm.dart';
import '../view_models/stream_vm.dart';

/// The top bar that exists in most views. On the homepage it has a profile button
/// that leads to [MenuView] while for other views it displays a back button.
class CommentNavBar extends StatelessWidget {
  /// A const constructor for [CommentNavBar]
  const CommentNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NavVM navVM = Provider.of<NavVM>(context);

    return Visibility(
      visible: Provider.of<MainVM>(context).isSignedIn,
        child: BottomNavigationBar(
          elevation: 30,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Sök',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.house),
              label: 'Hem',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic_none),
              label: 'Gå live!',
            ),
          ],
          currentIndex: navVM.currentTabIndex,
          onTap: (index) {
            context.read<StreamVM>().closeClient();
            switch (index) {
              case 1: navVM.selectTab(TabId.home);
              break;
              case 2: navVM.selectTab(TabId.live);
            }
          }
        ),
    );
  }
}
