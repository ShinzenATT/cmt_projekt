import 'dart:async';
import 'dart:io';
import 'package:cmt_projekt/apis/database_api.dart';
import 'package:cmt_projekt/apis/prefs.dart';
import 'package:cmt_projekt/models/channel_data_model.dart';
import 'package:cmt_projekt/widgets/error_dialog_box.dart';
import 'package:cmt_projekt/models/app_model.dart';
import 'package:cmt_projekt/models/query_model.dart';
import 'package:cmt_projekt/widgets/go_live_settings_dialog.dart';
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

  /// The constructor checks for login information as well
  MainVM() { checkLogIn(); }

  /// Persistent Models & API's with routing getters///

  // AppModel with App data & DatabaseAPI //
  /// For general and mostly constant App-data and API connection to database.
  static final AppModel appModel = AppModel();
  /// see [appModel]
  AppModel get app => appModel;
  /// an instance of [DatabaseApi] client
  DatabaseApi get dbClient => app.databaseApi;


  // UserModel for User & NewUserAccount data & locally stored/Shared preferences //
  /// Stores all relevant user & account data. Default to empty userdata fields
  /// and with 'isGuest' & 'isSignedIn' == false.
  static final UserModel userModel = UserModel();
  /// see [userModel]
  UserModel get user => userModel;

  // ChannelModel //
  // ChannelModel stores all relevant channel data, whether it is for
  // listening or for hosting.
  //static final ChannelModel channelModel = ChannelModel();

  /// the currently selected category set by [GoLiveSettings] dialog
  String? _category;

  // Settings & Helpers //

  /// Indicates if a user is signed in
  bool get isSignedIn => user.isSignedIn;

  /// Performed every time the app is started to check phone storage for
  /// already logged in user.
  void checkLogIn() {
    if (Prefs().storedData.getString("email") != null) {
      user.setUserFromPrefs();
      notifyListeners();
    }
  }

  /// Log out and clears user data from storage and model
  void logOut(context) {
    Prefs().storedData.clear();
    user.logOut();
    Provider.of<NavVM>(context, listen: false).loggedOut();
    notifyListeners();
  }


  // LoginView & CreateAccountView data & methods //

  /// Controls the show/hide password feature.
  bool showPassword = false;
  /// toggles if the password is shown or not on account creation or login
  void toggleShowPassword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  /// the user data currently edited in account creation
  UserData get newUserData => user.newUser;

  /// Logs in as guest and sets sample data
  void guestSign(context) async {
    Prefs().storedData.setString("uid", Uri().toString());
    Prefs().storedData.get("uid");
    user.isGuest = true;
    user.isSignedIn = true;
    Provider.of<NavVM>(context, listen: false).selectTab(TabId.home);
  }

  /// Tries to login by checking with dbServer
  void loginAttempt(context, login, password) {
    setUpResponseStream(context);
    dbClient.postAndSaveToStreamCtrl(
        '/account/login',
        QueryModel.login(email: login!, password: password!)
    );
  }

  /// Tries to create account in dbServer
  Future<void> tryCreateAccount(context, eMail, username, phoneNr, password, password2) async {
    RegExp exp1 = RegExp(r"[^\s]{8,50}$");
    if (!exp1.hasMatch(password)) {
      await ErrorDialogBox().show(
          context,
          "Lösenorden måste var mellan 8 och 50 tecken långt och får ej innehålla några blanksteg"
      );
      return;
    }
    // Check so that passwords matches
    if (password != password2) {
      await ErrorDialogBox().show(
          context,
          "Lösenorden stämmer inte överens"
      );
      return;
    }
    // Check that phone number is a ten digit number
    RegExp exp2 = RegExp(r"(?<!\d)\d{10}(?!\d)");
    if (!exp2.hasMatch(phoneNr)) {
      await ErrorDialogBox().show(
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
      await ErrorDialogBox().show(context, e.message);
    } on TimeoutException {
      await ErrorDialogBox().show(context, 'Kunde inte nå servern');
    } catch(e){
      constants.logger.i(e.runtimeType);
      await ErrorDialogBox().show(context, e.toString());
    }
  }

  /// Database response stream for login and create account
  /// Initiates a method that listens for new values and if it succeeds saves the
  /// credentials and redirects the app to the homeView.
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


  // Channel Settings //

  /// Gets a map that connects categories to image urls
  Map<String, String> get categoryImageList => app.categoryAndStandardImg;
  /// sets the selected channel category
  void setCategory(var item) => _category = item;
  /// the selected category in [GoLiveSettings] dialog
  String? get category => _category;
  /// The textfield for channel name
  TextEditingController get channelName => appModel.channelName;
  /// the start timestamp of the currently edited timetable entry, setter only sets date
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

  /// the start time of the currently edited timetable entry, saves to the DateTime version
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
  /// the end timestamp of the currently edited timetable entry, setter only sets date
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
  /// the end time of the currently edited timetable entry, saves to the DateTime version
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
  /// compiles a model obj from all text fields/pickers in [GoLiveSettings] dialog
  ChannelDataModel get channelData => ChannelDataModel(
      channelid: getUid()!,
      channelname: channelName.text,
      category: _category!,
      description: app.channelDescription.text.isNotEmpty ? app.channelDescription.text: null,
      timetable: app.timetable,
      username: getUsername()!
  );

  /// saves some channel settings to phone storage, see [Prefs]
  void setChannelSettings() {
    Prefs().storedData.setString("channelName", channelName.value.text);
    Prefs().storedData.setString("category", category!);
    Prefs().storedData.setString("intent", "h");
  }

  /// converts a string to a Dropdown item
  DropdownMenuItem<String> categoryItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );

  /// converts categories to a Dropdown list
  List<DropdownMenuItem<String>> categoryToDropdownMenuItemList() {
    return appModel.categoryAndStandardImg.keys.map(categoryItem).toList();
  }


  ///Returns the user's email from phone storage
  String? getEmail() {
    return Prefs().storedData.getString("email");
  }

  /// Returns the user's phone number from phone storage
  String? getPhone() {
    return Prefs().storedData.getString("phone");
  }

  /// Returns the user's username from phone storage
  String? getUsername() {
    return Prefs().storedData.getString("username");
  }

  ///Returns the users uID.
  String? getUid() {
    return Prefs().storedData.getString("uid");
  }

  /// renders a dialog with stored user information, see [ProfileInformation]
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


  /// reloads channel list from dbServer
  void updateChannels() {
    dbClient.loadOnlineChannels();
  }

  /// Organizes a list of all channels into a map where each
  /// category references a list of channels.
  Map<String, List<ChannelDataModel>> getCategoryNumber(List<ChannelDataModel> l) {
    Map<String, List<ChannelDataModel>> categories = {};
    for (ChannelDataModel qm in l) {
      if (qm.isonline) {
        if (!categories.containsKey(qm.category)) {
          categories[qm.category] = [];
        }
        categories[qm.category]!.add(qm);
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

  /// Sets [Prefs] values for joining a stream
  void setJoinPrefs(String channelId, String channelName, String username) {
    Prefs().storedData.setString("joinChannelID", channelId);
    Prefs().storedData.setString("intent", "j");
    Prefs().storedData.setString("channelName", channelName);
    Prefs().storedData.setString("hostUsername", username);
  }

  /// checks if mic permission is granted
  Future<bool> checkMicPermssion() async {
    if (await Permission.microphone.isGranted) {
      return true;
    }
    return false;
  }

  /// opens a mic permission dialog
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
