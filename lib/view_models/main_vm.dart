import 'dart:async';
import 'dart:io';
import 'package:cmt_projekt/apis/database_api.dart';
import 'package:cmt_projekt/apis/prefs.dart';
import 'package:cmt_projekt/models/channel_data_model.dart';
import 'package:cmt_projekt/widgets/error_dialog_box.dart';
import 'package:cmt_projekt/models/app_model.dart';
import 'package:cmt_projekt/models/query_model.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:cmt_projekt/constants.dart' as constants;
import 'package:provider/provider.dart';
import '../models/navigation_model.dart';
import '../models/user_model.dart';
import '../widgets/no_account_dialog.dart';
import '../widgets/profile_information_box.dart';
import 'package:cmt_projekt/widgets/no_account_dialog.dart';
import 'navigation_vm.dart';

/// The MainViewModel is used to deliver, modify and perform functions on data
/// retrieved from the MainModel. Its purpose is to act as an intermediary
/// between the views and the MainModel. Views should never directly access
/// the MainModel, but instead use MainViewModel to get what they need to build
/// their UI.
class MainVM with ChangeNotifier {

  MainVM() { checkLogIn(); }

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

  /// Check login
  // Performed every time the app is started to check phone storage for
  // already logged in user.
  void checkLogIn() {
    if (Prefs().storedData.getString("email") != null) {
      user.setUserFromPrefs();
      notifyListeners();
    }
  }

  /// Log out
  void logOut(context) {
    Prefs().storedData.clear();
    user.logOut();
    Provider.of<NavVM>(context, listen: false).loggedOut();
    notifyListeners();
  }


  /// LoginView & CreateAccountView data & methods///

  // Controls the show/hide password feature.
  bool showPassword = false;
  void toggleShowPassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  UserData get newUserData => user.newUser;

  /// Guest log in
  void guestSign(context) async {
    Prefs().storedData.setString("uid", Uri().toString());
    Prefs().storedData.get("uid");
    user.isGuest = true;
    user.isSignedIn = true;
    Provider.of<NavVM>(context, listen: false).selectTab(TabId.home);
  }

  /// Tries to login
  void loginAttempt(context, login, password) {
    setUpResponseStream(context);
    dbClient.postAndSaveToStreamCtrl(
        '/account/login',
        QueryModel.login(email: login!, password: password!)
    );
  }

  /// Tries to create account
  Future<void> tryCreateAccount(context, eMail, username, phoneNr, password, password2) async {
    RegExp exp1 = RegExp(r"[^\s]{8,50}$");
    if (!exp1.hasMatch(password)) {
      await ErrorDialogBox().pop(
          context,
          "Lösenorden måste var mellan 8 och 50 tecken långt och får ej innehålla några blanksteg"
      );
      return;
    }
    // Check so that passwords matches
    if (password != password2) {
      await ErrorDialogBox().pop(
          context,
          "Lösenorden stämmer inte överens"
      );
      return;
    }
    // Check that phone number is a ten digit number
    RegExp exp2 = RegExp(r"(?<!\d)\d{10}(?!\d)");
    if (!exp2.hasMatch(phoneNr)) {
      await ErrorDialogBox().pop(
          context,
          "Telefonnumret behöver vara på 10 siffror"
      );
      return;
    }
    setUpResponseStream(context);
    createAccount(context, eMail, username, phoneNr, password);
  }

  /// Creates the new account
  void createAccount(context, eMail, username, phoneNr, password) async {
    var hashedPassword = DBCrypt().hashpw(password, DBCrypt().gensalt());
    try {
      await dbClient.postAndSaveToStreamCtrl(
        '/account/register',
        QueryModel.account(
          email: eMail,
          phone: phoneNr,
          password: hashedPassword,
          username: username,
        ),
      );
    } on HttpException catch(e){
      await ErrorDialogBox().pop(context, e.message);
    } on TimeoutException {
      await ErrorDialogBox().pop(context, 'Kunde inte nå servern');
    } catch(e){
      constants.logger.i(e.runtimeType);
      await ErrorDialogBox().pop(context, e.toString());
    }
  }

  /// Database response stream for login and create account
  // Initiates a method that listens for new values and if it succeeds saves the
  // credentials and redirects the app to the homeView.
  Future<void> setUpResponseStream(context) async {
    dbClient.streamController.stream.listen((QueryModel message) async {
      await Prefs().storedData.setString("uid", message.uid!);
      await Prefs().storedData.setString("email", message.email!);
      await Prefs().storedData.setString("phone", message.phone!);
      await Prefs().storedData.setString("username", message.username!);
      newUserData.uid = message.uid;
      newUserData.eMail = message.email;
      newUserData.phoneNr = message.phone;
      newUserData.userName = message.username;
      user.setNewUser();
      dbClient.loadOnlineChannels();
      Provider.of<NavVM>(context, listen: false).selectTab(TabId.home);
    });
  }


  /// ChannelView ///
  Map<String, String> get categoryImageList => app.categoryAndStandardImg;
  void setCategory(var item) => _category = item;
  String? get category => _category;
  TextEditingController get channelName => appModel.channelName;
  DateTime get timetableStartTimestamp => app.timetableStartTimestamp;
  set timetableStartTimestamp (DateTime v) {
    app.timetableStartTimestamp = DateTime.utc(
        v.year,
        v.month,
        v.day,
        timetableStartTimestamp.hour,
        timetableStartTimestamp.minute
    );
    app.timetableStartDateStr.text = '${v.year}-${v.month}-${v.day}';
  }
  TimeOfDay get timetableStartTime => TimeOfDay.fromDateTime(app.timetableStartTimestamp);
  set timetableStartTime (TimeOfDay v) {
    app.timetableStartTimestamp = DateTime.utc(
        timetableStartTimestamp.year,
        timetableStartTimestamp.month,
        timetableStartTimestamp.day,
        v.hour,
        v.minute
    );
    app.timetableStartTimeStr.text = '${v.hour}:${v.minute}';
  }
  DateTime get timetableEndTimestamp => app.timetableEndTimestamp ?? DateTime.now();
  set timetableEndTimestamp (DateTime v) {
    app.timetableEndTimestamp = DateTime.utc(
        v.year,
        v.month,
        v.day,
        timetableEndTimestamp.hour,
        timetableEndTimestamp.minute
    );
    app.timetableEndDateStr.text = '${v.year}-${v.month}-${v.day}';
  }
  TimeOfDay get timetableEndTime => TimeOfDay.fromDateTime(timetableEndTimestamp);
  set timetableEndTime (TimeOfDay v) {
    app.timetableEndTimestamp = DateTime.utc(
        timetableEndTimestamp.year,
        timetableEndTimestamp.month,
        timetableEndTimestamp.day,
        v.hour,
        v.minute
    );
    app.timetableEndTimeStr.text = '${v.hour}:${v.minute}';
  }
  ChannelDataModel get channelData => ChannelDataModel(
      channelid: getUid()!,
      channelname: channelName.text,
      category: _category!,
      description: app.channelDescription.text.isNotEmpty ? app.channelDescription.text: null,
      timetable: app.timetable,
      username: getUsername()!
  );

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
    if (Prefs().getEmail == null) {
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

  /// collects data from various [TextEditingController]s and [DateTime]s found in [AppModel]
  /// in order to add a new [TimetableEntry] to the [AppModel.timetable].
  void addToTimetable(){
    app.timetable.add(TimetableEntry(
        channel: getUid()!,
        startTime: timetableStartTimestamp,
        endTime: app.timetableEndTimestamp,
        description: app.timetableDescription.text.isNotEmpty ? app.timetableDescription.text: null
    ));
  }
}
