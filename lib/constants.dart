import 'package:logger/logger.dart';

/// All the constants used throughout the project.

//Page-references
const String home = '/Home';
const String createAcc = '/CreateAccount';
const String demo = '/Demo';
const String hostChannel = '/HostChannel';
const String joinChannel = '/JoinChannel';
const String goLive = '/goLive';
const String goLive2 = '/goLive2';
const String login = '/login';
const String menu = '/AppMenu';
const String welcome = '/AppWelcome';

//dbLogic
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

Logger logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0
  )
);
