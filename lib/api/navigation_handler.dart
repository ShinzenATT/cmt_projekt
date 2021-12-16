//package imports
import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/app/View/app_channelpage.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/viewmodel/stream_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///A static singleton class to handle bottomnavigationbar for the app.
class NaviHandler {
  static final NaviHandler _navi = NaviHandler._internal();

  ///Index starts at number one because the home page is at index one in the naviagtion bar
  int index = 1;
  int previousIndex = 1;

  ///context from the current active page in order to swap page correctly.
  late BuildContext _context;

  factory NaviHandler() {
    return _navi;
  }

  NaviHandler._internal();

  ///Takes in the context of the current page.
  void setContext(var contexts) {
    _context = contexts;
  }

  /// Takes an index as indicator of which page that corresponds to the same button.
  void changePage(int i) {
    if (i == index) {
      return;
    } else if (i == 0) {
      if (previousIndex == 2) {
        _context.read<StreamViewModel>().closeClient();
      }
      previousIndex = i;
    } else if (i == 1) {
      if (previousIndex == 2) {
        _context.read<StreamViewModel>().closeClient();
        previousIndex = i;
        Navigator.of(_context).pushReplacementNamed(home);
      }
      if (previousIndex == 0) {
        previousIndex = i;
      }
    } else {
      previousIndex = i;
      Navigator.of(_context).pushReplacementNamed(goLive);
      // Prefs().storedData.setString("intent", "h");
      // _context.read<StreamViewModel>().startup(_context);
      // Navigator.of(_context).pushReplacementNamed(appChannel);
    }
    index = i;
  }
}
