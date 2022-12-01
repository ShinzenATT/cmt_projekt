import 'package:flutter/material.dart';
import 'package:cmt_projekt/constants.dart' as constants;
import 'package:provider/provider.dart';

import '../view_models/main_vm.dart';


///This is a reusable AppBar which is used in almost every view. It's created
///in the MainViewModel for easy access by all views.

class CommentAppBar extends StatelessWidget implements PreferredSizeWidget {
  //Variables
  late final double height;

  //Constructor
  CommentAppBar(BuildContext context, {Key? key}) : super(key: key)  {
    height = context.watch<MainViewModel>().appBarHeight;
  }

  // Determines preferred size if otherwise unconstrained.
  // Has to be defined to implement PreferredSizeWidget
  @override
  Size get preferredSize => Size.fromHeight(height);

  //Builds the widget
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(constants.menu);
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
                  context.watch<MainViewModel>().getUsername() ?? 'Gäst',
                  style: const TextStyle(fontSize: 13.0),
                ),
              ),
            ],
          ),
        ),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.greenAccent,
                  Colors.blueAccent,
                ])),
      ),
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          Text(
            context.watch<MainViewModel>().title.toUpperCase(),
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Text(
            context.watch<MainViewModel>().subtitle,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}