
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

  String? eMail;
  String? userName;
  String? phoneNr;
  String? password;
  String? password2;

  UserData();
}
