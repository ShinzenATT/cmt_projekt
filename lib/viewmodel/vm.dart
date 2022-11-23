import 'package:cmt_projekt/api/database_api.dart';
import 'package:cmt_projekt/api/navigation_handler.dart';
import 'package:cmt_projekt/api/prefs.dart';
import 'package:cmt_projekt/app/View/app_golivesettings.dart';
import 'package:cmt_projekt/app/View/app_homepage.dart';
import 'package:cmt_projekt/app/View/app_profilepage.dart';
import 'package:cmt_projekt/constants.dart';
import 'package:cmt_projekt/model/main_model.dart';
import 'package:cmt_projekt/model/query_model.dart';
import 'package:cmt_projekt/website/View/web_channelsettings.dart';
import 'package:cmt_projekt/website/View/web_createaccountwidget.dart';
import 'package:cmt_projekt/website/View/web_profilewidget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import '../../constants.dart' as constant;
import 'package:dbcrypt/dbcrypt.dart';

import '../app/View/app_createaccountpage.dart';

/*
  The main ViewModel used by the main Model and
  the majority of Views
 */

final navigatorKey = GlobalKey<NavigatorState>(); // Fore test purpose


class VM with ChangeNotifier {
  Model lm = Model();

  Map<String, String> get categoryList => lm.categoryAndStandardImg;
  get getCategory => lm.category;
  void setCategory(var item) {
    lm.category = item;
  }

  bool get passwordVisibilityLogin => lm.passwordVisibilityLogin;
  TextEditingController get login => lm.login;
  TextEditingController get password => lm.password;

  DatabaseApi get databaseAPI => lm.databaseAPI;

  bool get passwordVisibilityCreate => lm.passwordVisibilityCreate;
  String get title => lm.title.toUpperCase();
  TextEditingController get email => lm.createEmail;
  TextEditingController get phone => lm.createPhone;
  TextEditingController get password1 => lm.createPassword;
  TextEditingController get password2 => lm.createPassword2;
  TextEditingController get username => lm.createUsername;
  DatabaseApi get client => lm.databaseAPI;

  TextEditingController get channelName => lm.channelName;

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
    return lm.categoryAndStandardImg.keys.map(categoryItem).toList();
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
    return Prefs().storedData.get("uid").toString();
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
    if (kIsWeb) {
      showDialog(
          context: context,
          builder: (context) {
            return const WebProfileWidget();
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const AppProfileWidget();
          });
    }
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
    if (kIsWeb) {
      showDialog(
          context: context,
          builder: (context) {
            return WebChannelSettings();
          });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const GoLiveSettings();
          });
    }
  }

  void createAccountPrompt(context) {
    Prefs().storedData.clear();
    NaviHandler().index = 1;
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (kIsWeb) {
      showDialog(
          context: context,
          builder: (context) {
            return const WebCreateAccountWidget();
          });
    } else {
      Navigator.of(context).pushNamed(constant.createAcc);
    }
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
    lm.passwordVisibilityLogin = !passwordVisibilityLogin;
    notifyListeners();
  }

  /// From loginpageviewmodel
  void changePage(var context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  /// From loginpageviewmodel
  void loginAttempt(context) async {
    setUpResponseStreamLogin(context);
    databaseAPI.sendRequest(QueryModel.login(
        email: login.value.text, password: password.value.text));
  }

  /// From loginpageviewmodel
  void guestSign(context) async {
    setUpResponseStreamLogin(context);
    Prefs().storedData.setString("uid", const Uuid().v4());
    Prefs().storedData.get("uid");
    Navigator.pushNamedAndRemoveUntil(context, home, (route) => route.isFirst);
  }

  /// From loginpageviewmodel
  ///Initiates a function that runs when a new value comes from the response stream for the database.
  void setUpResponseStreamLogin(context) {
    print("void setUpResponseStreamLogin(context)");
    databaseAPI.streamController.stream.listen((QueryModel message) async {
      await Prefs().storedData.setString("uid", message.uid!);
      await Prefs().storedData.setString("email", message.email!);
      await Prefs().storedData.setString("phone", message.phone!);
      await Prefs().storedData.setString("username", message.username!);
      // Poppar Dialogrutan och gör så att den nuvarande rutan är loginpage.
      Navigator.of(context).pushNamedAndRemoveUntil(home, (route) => false);
      //Navigator.of(context)
      //    .pushReplacementNamed('/Home'); // Changes to HomePage.
      lm.databaseAPI.sendRequest(QueryModel.getChannels());
    });
  }

  /// From createaccountviewmodel
  void changePasswordVisibilityCreate() {
    lm.passwordVisibilityCreate = !lm.passwordVisibilityCreate;
    notifyListeners();
  }

  /// From createaccountviewmodel
  /// Check so that passwords matches
  Future<void> comparePw(var context) async {
    if (password1.value.text == password2.value.text) {
      checkPhonenumber(context);
    } else {
      await showErrorDialog(
          context,
          "Lösenorden stämmer inte överens"
      );
    }
  }
  /// From createaccountviewmodel
  /// Check so that phone number is a ten digit number
  Future<void> checkPhonenumber(var context) async {
    RegExp exp = RegExp(r"(?<!\d)\d{10}(?!\d)");
    if (exp.hasMatch(phone.value.text)) {
      setUpResponseStreamCA(context);
      createAccount();
    } else {
      await showErrorDialog(
          context,
          "Telefonnumret behöver vara på 10 siffror"
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
      databaseAPI.sendRequest(QueryModel.getChannels());
    });
  }

  /// From createaccountviewmodel
  void createAccount() {
    var hashedPassword = DBCrypt().hashpw(password1.value.text, DBCrypt().gensalt());
    client.sendRequest(
      QueryModel.account(
        email: email.value.text,
        phone: phone.value.text,
        password: hashedPassword,
        username: username.value.text,
      ),
    );
  }

  void updateChannels() {
    databaseAPI.sendRequest(QueryModel.getChannels());
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
      if (qm.channelName == channelName) {
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
