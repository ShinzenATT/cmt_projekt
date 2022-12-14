import 'package:cmt_projekt/view_models/navigation_vm.dart';
import 'package:cmt_projekt/views/home_views/menu_view.dart';
import 'package:flutter/material.dart';
import 'package:cmt_projekt/views/home_views/channels_view.dart';
import 'package:cmt_projekt/views/home_views/listen_channel_view.dart';
import 'package:cmt_projekt/constants.dart' as constants;
import 'package:provider/provider.dart';


class HomeNavigatorView extends StatelessWidget {
  const HomeNavigatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Provider.of<NavVM>(context).homeNavKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            switch(settings.name) {
              case constants.channels:
                return const ChannelsView();
              case constants.listenChannel:
                return const ListenChannelView();
              case constants.menu:
                return const MenuView();
              default:
                return const ChannelsView();
            }
          },
        );
      },
    );
  }
}