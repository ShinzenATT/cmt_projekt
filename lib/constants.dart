import 'package:logger/logger.dart';


/// All constant phrases and data used throughout the project is collected here.

/// Page-routing references ///
/// To not have to remember all of them specifically.
/// 'mainApp' is the landing-page for the App and reroutes the user depending on
/// if they're logged in or not.

const String mainApp = '/';                        // Reroutes to WelcomeView or MainNavigatorView.
const String welcome = '/welcomeView';
const String login = '/loginView';                 // Login view.
const String createAccount = '/createAccountView'; // Create account view.

const String channels = '/channelsView';           // Main page of the 'Hem' tab.
const String listenChannel = '/listenChannelView'; // The view for listening to a channel.
const String menu = '/menuView';                   // Profile/Settings view.

const String goLive = '/goLive';                   // Main page of the 'Gå live!' tab.
const String goLive2 = '/goLive2';                 // Next page, where the microphone is checked.
const String hostChannel = '/hostChannelView';         // Where you host a channel and actually go live.


/// Constants that are easier to remember than the numbers that the database
/// wants.
const String dbLogin = "0";
const String dbAccount = "1";
const String dbGetInfo = "2";
const String dbCreateChannel = "3";
const String dbChannelOffline = "4";
const String dbGetOnlineChannels = "5";
const String dbPing = "6";
const String dbAddViewers = "7";
const String dbDelViewers = "8";
const String dbDelViewer = "9";

/// Logger for writing text to the console, used for debugging.
final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0
  )
);