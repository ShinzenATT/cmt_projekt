import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static final Prefs _preference = Prefs._internal();
  late SharedPreferences storedData;
  factory Prefs() {
    return _preference;
  }

  String? getEmail() {
    return storedData.getString('email');
  }

  String? getIntent(){
    return storedData.getString('intent');
  }

  String? getJoinChannelID(){
    return storedData.getString('joinChannelID');
  }

  String? joinHost(){
    return storedData.getString('joinHost');
  }

  Prefs._internal() {
    setUp();
  }

  void setUp() async {
    storedData = await SharedPreferences.getInstance();
  }
}
