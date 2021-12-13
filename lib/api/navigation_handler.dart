//package imports
import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/app/View/app_channelpage.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/viewmodel/stream_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///A static singleton class to handle navigation to different pages.
class NaviHandler {
  static final NaviHandler _navi = NaviHandler._internal();

  ///Index starts at number one because the home page is at index one in the naviagtion bar
  int index = 1;

  ///context from the current active page in order to swap page correctly.
  late BuildContext _context;

  factory NaviHandler() {
    return _navi;
  }

  NaviHandler._internal();

  ///Takes in the context of the current page.
  void setContext(var contexts) {
    this._context = contexts;
  }

  /// Takes an index as indicator of which page that corresponds to the same button.
  void changePage(int i) {
    if (i == index) {
      return;
    } else if (i == 0) {
      //Navigator.of(_context).pushReplacementNamed('/exercise');
    } else if (i == 1) {
      Navigator.of(_context).pushReplacementNamed(home);
    } else {
      Prefs().storedData.setString("intent", "h");
      _context.read<StreamViewModel>().startup(_context);
      Navigator.of(_context).pushNamed(appChannel);
    }
    index = i;
  }
}
