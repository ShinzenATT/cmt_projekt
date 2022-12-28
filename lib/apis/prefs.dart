import 'package:shared_preferences/shared_preferences.dart';

/// A singleton class for storing data to phone storage
class Prefs {
  static final Prefs _preference = Prefs._internal();
  /// the interface to store and retrieve data from phone storage
  late SharedPreferences storedData;
  /// A factory the returns the singleton
  factory Prefs() {
    return _preference;
  }

  /// gets the email from phone storage, it's null if none is found
  String? get getEmail => storedData.getString('email');

  /// gets the stream intent which can either be `h` (host) or `j` (join/listen)
  /// from phone storage, it's null if it's not set
  String? get getIntent => storedData.getString('intent');

  /// gets the channel uuid that is intended to be listened to, it's null if not set
  String? get getJoinChannelID => storedData.getString('joinChannelID');


  Prefs._internal() {
    //setUp();
  }

  /// the method used to instantiate the singleton, it should be called in main
  Future<void> setUp() async {
    storedData = await SharedPreferences.getInstance();
  }
}
