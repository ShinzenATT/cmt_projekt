import 'package:cmt_projekt/view_models/navigation_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:cmt_projekt/constants.dart' as constants;
import '../view_models/stream_vm.dart';

/// This is a persistent AppBar used in almost every view. It rebuilds itself
/// when notified by MainVM or NavigationVM and thus dynamically changes
/// its behaviour and design.
class CommentAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// A const constructor for [CommentAppBar]
  const CommentAppBar({Key? key}): super(key: key);

  // This override is necessary since it implements PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(80.0);

  @override
  Widget build(BuildContext context) {

    // Local variables that are listening for changes in the providers.
    MainVM mainVM = Provider.of<MainVM>(context);
    NavVM navVM = Provider.of<NavVM>(context);

    return Visibility(
      visible: navVM.showAppBar,
        child: AppBar(
          leading: Builder(
            // This builder presents the BackButton if the active navigator has
            // anything to pop, otherwise presents account symbol & name.
            builder: (BuildContext context) {
              if(navVM.canPop){
                return BackButton(
                  onPressed: () {
                    context.read<StreamVM>().closeClient();
                    navVM.goBack(context);

                  },
                );
              } else {
                return InkWell(
                  onTap: () {
                    context.read<StreamVM>().closeClient();
                    navVM.pushView(constants.menu);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                          child: Icon(Icons.account_circle_outlined),
                        ),
                        Center(
                          child: Text(
                            // Writes out username if logged in, otherwise 'Guest'
                            mainVM.getUsername() ?? 'Gäst',
                            style: const TextStyle(fontSize: 13.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.greenAccent,
                    Colors.blueAccent,
                  ]),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: Column(
            children: [
              Text(
                // Takes title from MainVM
                mainVM.app.title.toUpperCase(),
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                // Takes subtitle from MainVM
                mainVM.app.subTitle,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          ),
        )
    );
  }
}
