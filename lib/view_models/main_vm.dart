import 'dart:async';
import 'dart:io';

import 'package:cmt_projekt/apis/database_api.dart';
import 'package:cmt_projekt/apis/navigation_handler.dart';
import 'package:cmt_projekt/apis/prefs.dart';
import 'package:cmt_projekt/views/golivesettings_view.dart';
import 'package:cmt_projekt/views/home_view.dart';
import 'package:cmt_projekt/views/profile_view.dart';
import 'package:cmt_projekt/models/main_model.dart';
import 'package:cmt_projekt/models/query_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:cmt_projekt/constants.dart' as constant;
import 'package:dbcrypt/dbcrypt.dart';

import '../views/createaccount_view.dart';

//final navigatorKey = GlobalKey<NavigatorState>(); // For test purpose

///The MainViewModel is used to deliver, modify and perform functions on data
///retrieved from the MainModel. Its purpose is to act as an intermediary
///between the views and the MainModel. Views should never directly access
///the MainModel, but instead use MainViewModel to get what they need to build
///their UI.

class MainViewModel with ChangeNotifier {

  ///MainModel to use for data access.
  static final MainModel _mainModel = MainModel();

  ///Getter functions
  String get title => _mainModel.title;
  String get subtitle => _mainModel.subTitle;
  double get appBarHeight => _mainModel.appBarHeight;



  Map<String, String> get categoryList => _mainModel.categoryAndStandardImg;
  get getCategory => _mainModel.category;
  void setCategory(var item) {
    _mainModel.category = item;
  }

  bool get passwordVisibilityLogin => _mainModel.passwordVisibilityLogin;
  TextEditingController get login => _mainModel.login;
  TextEditingController get password => _mainModel.password;

  DatabaseApi get databaseAPI => _mainModel.databaseAPI;

  bool get passwordVisibilityCreate => _mainModel.passwordVisibilityCreate;
  TextEditingController get email => _mainModel.createEmail;
  TextEditingController get phone => _mainModel.createPhone;
  TextEditingController get password1 => _mainModel.createPassword;
  TextEditingController get password2 => _mainModel.createPassword2;
  TextEditingController get username => _mainModel.createUsername;
  DatabaseApi get client => _mainModel.databaseAPI;

  TextEditingController get channelName => _mainModel.channelName;

  void setChannelSettings() {
    Prefs().storedData.setString("channelName", channelName.value.text);
    Prefs().storedData.setString("category", getCategory);
    Prefs().storedData.setString("intent", "h");

  }

  DropdownMenuItem<String> categoryItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
        ),
      );

  dynamic categoryToDropdownMenuItemList() {
    return _mainModel.categoryAndStandardImg.keys.map(categoryItem).toList();
  }

  Future<bool> willPopCallback() async {
    NaviHandler().index = 1;
    notifyListeners();
    return true;
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

  ///Creates a showdialog with webprofilewidget.
  void profileInformation(context) {
    if (getEmail() == null) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertMessage();
          });
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          return const AppProfileWidget();
        });
  }

  void channelSettings(context) {
    if (getEmail() == null) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertMessage();
          });
      return;
    }
    showDialog(
        context: context,
        builder: (context) {
          return const GoLiveSettings();
        });
  }

  void createAccountPrompt(context) {
    Prefs().storedData.clear();
    NaviHandler().index = 1;
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushNamed(constant.createAcc);
  }

  void logOut(context) {
    Prefs().storedData.clear();
    NaviHandler().index = 1;
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (kIsWeb) {
      Navigator.of(context).pushReplacementNamed(constant.login);
    } else {
      Navigator.of(context).pushReplacementNamed(constant.welcome);
    }
  }

  /// From loginpageviewmodel
  void changePasswordVisibilityLogin() {
    _mainModel.passwordVisibilityLogin = !passwordVisibilityLogin;
    notifyListeners();
  }

  /// From loginpageviewmodel
  void changePage(var context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  /// From loginpageviewmodel
  void loginAttempt(context) async {
    setUpResponseStreamLogin(context);
    databaseAPI.postAndSaveToStreamCtrl(
        '/account/login',
        QueryModel.login(email: login.value.text, password: password.value.text)
    );
  }

  /// From loginpageviewmodel
  void guestSign(context) async {
    setUpResponseStreamLogin(context);
    Prefs().storedData.setString("uid", const Uuid().v4());
    Prefs().storedData.get("uid");
    Navigator.pushNamedAndRemoveUntil(context, constant.home, (route) => route.isFirst);
  }

  /// From loginpageviewmodel
  ///Initiates a function that runs when a new value comes from the response stream for the database.
  void setUpResponseStreamLogin(context) {
    debugPrint("void setUpResponseStreamLogin(context)");
    databaseAPI.streamController.stream.listen((QueryModel message) async {
      await Prefs().storedData.setString("uid", message.uid!);
      await Prefs().storedData.setString("email", message.email!);
      await Prefs().storedData.setString("phone", message.phone!);
      await Prefs().storedData.setString("username", message.username!);
      // Poppar Dialogrutan och gör så att den nuvarande rutan är loginpage.
      Navigator.of(context).pushNamedAndRemoveUntil(constant.home, (route) => false);
      //Navigator.of(context)
      //    .pushReplacementNamed('/Home'); // Changes to HomePage.
      _mainModel.databaseAPI.loadOnlineChannels();
    });
  }

  /// From createaccountviewmodel
  void changePasswordVisibilityCreate() {
    _mainModel.passwordVisibilityCreate = !_mainModel.passwordVisibilityCreate;
    notifyListeners();
  }

  /// From createaccountviewmodel
  /// Check so that passwords matches
  Future<void> comparePw(var context) async {
    if (password1.value.text == password2.value.text) {
      checkPwlength(context);
    } else {
      await showErrorDialog(
          context,
          "Lösenorden stämmer inte överens"
      );
    }
  }
  /// From createaccountviewmodel
  /// Check length of password and that it don't contains any white spaces.
  Future<void> checkPwlength(var context) async {
    RegExp exp = RegExp(r"[^\s]{8,50}$");
    print(password1.value.text);
    if (exp.hasMatch(password1.value.text)) {
      checkPhonenumber(context);
    } else {
      await showErrorDialog(
          context,
          "Lösenorden måste var mellan 8 och 50 tecken långt och får ej innehålla några blanksteg"
      );
    }
  }
  /// From createaccountviewmodel
  /// Check so that phone number is a ten digit number
  Future<void> checkPhonenumber(var context) async {
    RegExp exp = RegExp(r"(?<!\d)\d{10}(?!\d)");
    if (exp.hasMatch(phone.value.text)) {
      checkMail(context);
    } else {
      await showErrorDialog(
          context,
          "Telefonnumret behöver vara på 10 siffror"
      );
    }
  }
  /// From createaccountviewmodel
  /// Check so that email address at least looks like a valid email address.
  Future<void> checkMail(var context) async {
    RegExp exp = RegExp(r"^[\w!#$%&’*+/=?`{|}~^-]+(?:\.[\w!#$%&’*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}$");
    if (exp.hasMatch(email.value.text)) {
      checkUsername(context);
    }
    else {
      await showErrorDialog(
          context,
          "Du måste ange en giltlig mejladress"
      );
    }
  }
  /// From createaccountviewmodel
  /// Check so that username are [3,20] characters long
  Future<void> checkUsername(var context) async {
    RegExp exp = RegExp(r"^[a-zåäöA-ZÅÄÖ0-9_-]{3,20}$");
    if (exp.hasMatch(username.value.text)) {
      setUpResponseStreamCA(context);
      createAccount(context);
    }else {
      await showErrorDialog(
          context,
          "Användarnamnte måste vara mella 3 och 20 tecken långt och får endast innehålla små och stora bockstäver, siffror, _ och -"
      );
    }
  }
  /// From createaccountviewmodel
  ///Initiates a function that runs when a new value comes from the response stream for the client.
  void setUpResponseStreamCA(context) {
    client.streamController.stream.listen((QueryModel message) async {
      var _context = context;
      await Prefs().storedData.setString("uid", message.uid!);
      await Prefs().storedData.setString("email", message.email!);
      await Prefs().storedData.setString("phone", message.phone!);
      await Prefs().storedData.setString("username", message.username!);
      if (kIsWeb) {
        // Poppar Dialogrutan och gör så att den nuvarande rutan är loginpage.
        Navigator.of(_context, rootNavigator: true).pop();
      }

      Navigator.of(_context)
          .pushReplacementNamed('/Home'); // Byter till homepage.
      databaseAPI.loadOnlineChannels();
    });
  }

  /// From createaccountviewmodel
  void createAccount(var ctx) async {
    var hashedPassword = DBCrypt().hashpw(password1.value.text, DBCrypt().gensalt());
    try {
      await client.postAndSaveToStreamCtrl(
        '/account/register',
        QueryModel.account(
          email: email.value.text,
          phone: phone.value.text,
          password: hashedPassword,
          username: username.value.text,
        ),
      );
    } on HttpException catch(e){
      await showErrorDialog(ctx, e.message);
    } on TimeoutException {
      await showErrorDialog(ctx, 'Kunde inte nå servern');
    } catch(e){
      constant.logger.i(e.runtimeType);
      await showErrorDialog(ctx, e.toString());
    }
  }

  void updateChannels() {
    databaseAPI.loadOnlineChannels();
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
