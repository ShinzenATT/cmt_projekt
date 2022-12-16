import '../apis/prefs.dart';

class UserModel {

  /// UserModel data & variables ///
  // Persistent variables that defaults to false
  bool isGuest = false;
  bool isSignedIn = false;

  /// User data for active user (if any).
  static UserData data = UserData();

  /// User data for new account
  static UserData newUserData = UserData();
  UserData get newUser => newUserData;

  /// Methods

  void setUserFromPrefs() {
    data.eMail = Prefs().storedData.getString("email");
    data.userName = Prefs().storedData.getString("username");
    data.phoneNr = Prefs().storedData.getString("phone");
    isSignedIn = true;
  }

  void setNewUser() {
    data = newUserData;
    newUserData = UserData();
    isSignedIn = true;
  }

  void logOut() {
    isGuest = false;
    isSignedIn = false;
    data = UserData();
    newUserData = UserData();
  }
}

/// UserData class ///
class UserData {

  String? uid;
  String? eMail;
  String? userName;
  String? phoneNr;
  String? password;
  String? password2;

  UserData();
}
