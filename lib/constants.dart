import 'package:cmt_projekt/views/go_live/go_live_settings_dialog.dart';
import 'package:logger/logger.dart';


// All constant phrases and data used throughout the project is collected here.

// Page-routing references //
// To not have to remember all of them specifically.
// 'mainApp' is the landing-page for the App and reroutes the user depending on
// if they're logged in or not.

/// Reroutes to WelcomeView or MainNavigatorView.
const String mainApp = '/';
/// landing page for first time users
const String welcome = '/welcomeView';
/// Login view.
const String login = '/loginView';
/// Create account view.
const String createAccount = '/createAccountView';
/// Main page of the 'Hem' tab.
const String channels = '/channelsView';
/// The view for listening to a channel.
const String listenChannel = '/listenChannelView';
/// Profile/Settings view.
const String menu = '/menuView';

/// Main page of the 'Gå live!' tab where they select the type of stream.
const String goLive = '/goLive';
/// Next page, where the microphone is checked and launches the [GoLiveSettings] dialog.
const String goLive2 = '/goLive2';
/// Where you host a channel and actually are streaming.
const String hostChannel = '/hostChannelView';

/// Logger for writing text to the console, used for debugging.
final Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0
  )
);