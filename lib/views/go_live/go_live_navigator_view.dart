import 'package:cmt_projekt/views/go_live/go_live_view1.dart';
import 'package:cmt_projekt/views/go_live/go_live_view2.dart';
import 'package:cmt_projekt/views/go_live/host_channel_view.dart';
import 'package:flutter/material.dart';
import 'package:cmt_projekt/constants.dart' as constants;
import 'package:provider/provider.dart';

import '../../view_models/navigation_vm.dart';


class GoLiveNavigatorView extends StatelessWidget {
  const GoLiveNavigatorView({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState>? navigatorKey;
  final TabId tabId;

  @override
  Widget build(BuildContext context) {

    return Navigator(
      key: Provider.of<NavVM>(context).,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch(settings.name) {
              case constants.goLive:
                return const GoLiveView1();
              case constants.goLive2:
                return const GoLiveView2();
              case constants.hostChannel:
                return const HostChannelView();
              default:
                return const GoLiveView1();
            }
          },
        );
      },
    );
  }
}
