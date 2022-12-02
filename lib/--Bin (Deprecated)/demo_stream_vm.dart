import 'package:cmt_projekt/apis/prefs.dart';
import 'package:flutter/cupertino.dart';

/// !!! DEPRECATED !!!
/// Created by previous group and moved to deprecated to clean up
/// project structure.

class DemoStreamViewModel with ChangeNotifier {
  TextEditingController tx = TextEditingController();

  TextEditingController get hostID => tx;
  void demoJoin() {
    Prefs().storedData.setString("joinChannelID", tx.value.text);
    debugPrint("HostID/Value/Text: " +
        tx.value.text);
    Prefs().storedData.setString("intent", "j");
  }
}
