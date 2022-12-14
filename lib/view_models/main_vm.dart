import 'dart:async';
import 'dart:io';
import 'package:cmt_projekt/apis/database_api.dart';
import 'package:cmt_projekt/apis/prefs.dart';
import 'package:cmt_projekt/widgets/error_dialog_box.dart';
import 'package:cmt_projekt/models/app_model.dart';
import 'package:cmt_projekt/models/query_model.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:cmt_projekt/constants.dart' as constants;
import '../models/user_model.dart';
import '../widgets/no_account_dialog.dart';
import '../widgets/profile_information_box.dart';
import 'package:cmt_projekt/widgets/no_account_dialog.dart';

/// The MainViewModel is used to deliver, modify and perform functions on data
/// retrieved from the MainModel. Its purpose is to act as an intermediary
/// between the views and the MainModel. Views should never directly access
/// the MainModel, but instead use MainViewModel to get what they need to build
/// their UI.
class MainVM with ChangeNotifier {

  /// Persistent Models & API's with routing getters///

  /// AppModel with App data & DatabaseAPI ///
  // For general and mostly constant App-data and API connection to database.
  static final AppModel appModel = AppModel();
  AppModel get app => appModel;
  DatabaseApi get dbClient => app.databaseApi;


  /// UserModel for User & NewUserAccount data & locally stored/Shared preferences ///
  // Stores all relevant user & account data. Default to empty userdata fields
  // and with 'isGuest' & 'isSignedIn' == false.
  static final UserModel userModel = UserModel();
  UserModel get user => userModel;


  /// ChannelModel ///
  // ChannelModel stores all relevant channel data, whether it is for
  // listening or for hosting.
  ///static final ChannelModel channelModel = ChannelModel();
  String? _category;


  /// Settings & Helpers ///
  bool get isSignedIn => user.isSignedIn;

  // For CreateAccountView & LoginView
  bool showPassword = false; // Controlls the show/hide password feature.
  UserData get newUserData => user.newUser;
  void toggleShowPassword() => showPassword = !showPassword;

  // For ChannelView
  Map<String, String> get categoryImageList => app.categoryAndStandardImg;
  void setCategory(var item) => _category = item;
  String? get category => _category;
  TextEditingController get channelName => appModel.channelName;

  void setChannelSettings() {
    Prefs().storedData.setString("channelName", channelName.value.text);
    Prefs().storedData.setString("category", category!);
    Prefs().storedData.setString("intent", "h");
  }

  DropdownMenuItem<String> categoryItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );

  dynamic categoryToDropdownMenuItemList() {
    return appModel.categoryAndStandardImg.keys.map(categoryItem).toList();
  }


  /// Create Account Helpers ///
  /// Check so that passwords matches
  Future<void> comparePw(var context) async {
    if (newUserData.password == newUserData.password2) {
      checkPhonenumber(context);
    } else {
      await ErrorDialogBox().pop(
          context,
          "Lösenorden stämmer inte överens"
      );
    }
  }

  /// Check that phone number is a ten digit number
  Future<void> checkPhonenumber(var context) async {
    RegExp exp = RegExp(r"(?<!\d)\d{10}(?!\d)");
    if (exp.hasMatch(newUserData.phoneNr!)) {
      setUpResponseStreamCA(context);
      createAccount(context);
    } else {
      await ErrorDialogBox().pop(
          context,
          "Telefonnumret behöver vara på 10 siffror"
      );
    }
  }

  /// Create the new account ///
  void createAccount(var ctx) async {
    var hashedPassword = DBCrypt().hashpw(newUserData.password!, DBCrypt().gensalt());
    try {
      await dbClient.postAndSaveToStreamCtrl(
        '/account/register',
        QueryModel.account(
          email: newUserData.eMail,
          phone: newUserData.phoneNr,
          password: hashedPassword,
          username: newUserData.userName,
        ),
      );
    } on HttpException catch(e){
      await ErrorDialogBox().pop(ctx, e.message);
    } on TimeoutException {
      await ErrorDialogBox().pop(ctx, 'Kunde inte nå servern');
    } catch(e){
      constants.logger.i(e.runtimeType);
      await ErrorDialogBox().pop(ctx, e.toString());
    }
  }

  ///Initiates a function that runs when a new value comes from the response stream for the client.
  void setUpResponseStreamCA(context) {
    dbClient.streamController.stream.listen((QueryModel message) async {
      await Prefs().storedData.setString("uid", message.uid!);
      await Prefs().storedData.setString("email", message.email!);
      await Prefs().storedData.setString("phone", message.phone!);
      await Prefs().storedData.setString("username", message.username!);

      user.setNewUser();
      dbClient.loadOnlineChannels();
    });
  }


  /// Log in! ///
  void loginAttempt(context) async {
    setUpResponseStreamLogin(context);
    dbClient.postAndSaveToStreamCtrl(
        '/account/login',
        QueryModel.login(email: newUserData.eMail!, password: newUserData.password!)
    );
  }

  /// Guest log in! ///
  void guestSign(context) async {
    setUpResponseStreamLogin(context);
    Prefs().storedData.setString("uid" ,Uri().toString());
    Prefs().storedData.get("uid");
    user.isGuest = true;
    user.isSignedIn = true;
  }

  /// Database response stream for Login ///
  //Initiates a function that listens for new values
  void setUpResponseStreamLogin(context) {
    debugPrint("void setUpResponseStreamLogin(context)");
    dbClient.streamController.stream.listen((QueryModel message) async {
      await Prefs().storedData.setString("uid", message.uid!);
      await Prefs().storedData.setString("email", message.email!);
      await Prefs().storedData.setString("phone", message.phone!);
      await Prefs().storedData.setString("username", message.username!);

      user.setNewUser();
      dbClient.loadOnlineChannels();
      debugPrint("void setUpResponseStreamLogin(context)- DONE!");
    });
  }

  /// Log out! ///
  void logOut(context) {
    Prefs().storedData.clear();
    user.logOut();
  }


  ///Returns the users email.
  String? getEmail() {
    return Prefs().storedData.getString("email");
  }

  String? getPhone() {
    return Prefs().storedData.getString("phone");
  }

  String? getUsername() {
    return Prefs().storedData.getString("username");
  }

  ///Returns the users uID.
  String? getUid() {
    return Prefs().storedData.getString("uid");
  }

  void userData(context) {
    if (Prefs().getEmail() == null) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertMessage();
          });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const ProfileInformation();
        },
      );
    }
  }



  void updateChannels() {
    dbClient.loadOnlineChannels();
  }

  /// Organizes a list of all channels into a map where each
  /// category references a list of channels.
  Map<String, List<QueryModel>> getCategoryNumber(List<QueryModel> l) {
    Map<String, List<QueryModel>> categories = {};
    for (QueryModel qm in l) {
      if (qm.isonline!) {
        if (!categories.containsKey(qm.category)) {
          categories[qm.category!] = [];
        }
        categories[qm.category!]!.add(qm);
      }
    }
    return categories;
  }

  /// Given a name and a list of QueryModel returns the QueryModel
  /// that corresponds with the name.
  /// Can return null
  QueryModel? getChannel(List<QueryModel> l, String channelName) {
    for (QueryModel qm in l) {
      if (qm.channelname == channelName) {
        return qm;
      }
    }
    return null;
  }

  void setJoinPrefs(String channelId, String channelName, String username) {
    Prefs().storedData.setString("joinChannelID", channelId);
    Prefs().storedData.setString("intent", "j");
    Prefs().storedData.setString("channelName", channelName);
    Prefs().storedData.setString("hostUsername", username);
  }

  Future<bool> checkMicPermssion() async {
    if (await Permission.microphone.isGranted) {
      return true;
    }
    return false;
  }

  Future<void> grantMicPermsission() async {
    await Permission.microphone.request();
    notifyListeners();
  }
}
