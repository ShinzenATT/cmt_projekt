/*
//package imports
import 'package:cmt_projekt/apis/prefs.dart';
import 'package:cmt_projekt/views/home/home_navigator_view.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/view_models/stream_vm.dart';
import 'package:cmt_projekt/view_models/main_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/no_account_dialog.dart';

 */

/// DEPRECATED - All navigation functionality now found in NavigationVM ///

/*
///A static singleton class to handle bottomnavigationbar for the app.
class NaviHandler {
  static final NaviHandler _navi = NaviHandler._internal();

  NaviHandler._internal();

  ///Index starts at number one because the home page is at index one in the naviagtion bar
  int index = 1;
  int previousIndex = 1;

  ///Context from the current active page in order to swap page correctly.
  late BuildContext _context;

  factory NaviHandler() {
    return _navi;
  }

  ///Takes in the context of the current page.
  void setContext(var contexts) {
    _context = contexts;
  }

  /// Takes an index as indicator of which page that corresponds to the same button.
  void changePage(int i) {
    if (i == index) {
      return;
    } else if (i == 0) {
      return;
      //TODO implementera detta då det finns en fungerande sök-sida.

    } else if (i == 1) {
      if (previousIndex == 2) {
        _context.read<StreamVM>().closeClient();
        _context.read<MainVM>().willPopCallback();
        Navigator.pop(_context);
        previousIndex = i;
      }
    } else {
      if (Prefs().getEmail() == null) {
        showDialog(
            context: _context,
            builder: (context) {
              return const AlertMessage();
            });
        return;
      }
      previousIndex = i;
      Navigator.of(_context).pushNamed(goLive);
    }
    index = i;
  }
}


 */