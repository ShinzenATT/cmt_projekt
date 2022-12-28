import '../apis/prefs.dart';

/// A model that contains account info and login status
class UserModel {

  // UserModel data & variables //
  // Persistent variables that defaults to false

  /// Indicates if guest mode is on
  bool isGuest = false;
  /// Indicates if a user is logged in
  bool isSignedIn = false;

  /// User data for active user (if any).
  static UserData data = UserData();

  /// User data for new account
  static UserData newUserData = UserData();
  /// User data set by account creation
  UserData get newUser => newUserData;

  // Methods

  /// Loads user data from phone local storage if any, see [Prefs]
  void setUserFromPrefs() {
    data.eMail = Prefs().storedData.getString("email");
    data.userName = Prefs().storedData.getString("username");
    data.phoneNr = Prefs().storedData.getString("phone");
    isSignedIn = true;
  }

  /// Loads user data from account creation
  void setNewUser() {
    data = newUserData;
    newUserData = UserData();
    isSignedIn = true;
  }

  /// Unloads user data
  void logOut() {
    isGuest = false;
    isSignedIn = false;
    data = UserData();
    newUserData = UserData();
  }
}

/// UserData class
class UserData {

  /// the uuid of the user
  String? uid;
  /// the user's email
  String? eMail;
  /// the user's username
  String? userName;
  /// the user's phone number
  String? phoneNr;
  /// the user's password
  String? password;
  /// the user's password, used during account creation
  String? password2;
}
