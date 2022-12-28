import 'package:cmt_projekt/apis/prefs.dart';
import 'package:flutter/cupertino.dart';

/// !!! DEPRECATED !!!
/// Created by previous group and moved to deprecated to clean up
/// project structure.

class DemoStreamViewModel with ChangeNotifier {
  /// text value for selecting host
  TextEditingController tx = TextEditingController();

  /// getter for getting text controller
  TextEditingController get hostID => tx;

  /// test method for joining a stream
  void demoJoin() {
    Prefs().storedData.setString("joinChannelID", tx.value.text);
    debugPrint("HostID/Value/Text: " +
        tx.value.text);
    Prefs().storedData.setString("intent", "j");
  }
}
