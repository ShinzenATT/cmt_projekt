import 'package:cmt_projekt/api/prefs.dart';
import 'package:flutter/cupertino.dart';

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
