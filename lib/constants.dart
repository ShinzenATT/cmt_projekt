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

// Urls for servers, use ipconfig or ifconfig to find your local ip
const String serverConnection = "ws://192.168.0.XXX:5605"; // url to connect with stream server
const String localServer = "192.168.0.XXX"; //IP of stream- & db api servers, port 5605/5604
const String dbConnection = 'localhost'; //IP of postgres db, port 5432
