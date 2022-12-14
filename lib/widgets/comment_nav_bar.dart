import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/navigation_vm.dart';

class CommentNavBar extends StatelessWidget {
  const CommentNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NavVM navVM = Provider.of<NavVM>(context);

    return BottomNavigationBar(
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
      onTap: (index) => navVM.selectTab(TabId.values[index]),
    );
  }
}
