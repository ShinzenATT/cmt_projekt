import 'package:cmt_projekt/constants.dart';

class QueryModel {
  String? email;
  String? phone;
  String? password;
  String? uid;
  String? channelid;
  String? code;
  String? channelname;
  String? category;
  String? username;
  bool? isonline;
  int? total;

  ///En Querymodel för att lägga till lyssnare
  QueryModel.addViewers({required this.channelid, required this.uid}){
    code = dbAddViewers;
  }

  QueryModel.delViewer({required this.channelid, required this.uid}){
    code = dbDelViewer;
  }

  QueryModel.delViewers({required this.channelid}){
    code = dbDelViewers;
  }

  ///En Querymodel som försöker skapa ett konto utifrån givna parametrar.
  QueryModel.account(
      {required this.email,
      required this.phone,
      required this.password,
      required this.username}) {
    code = dbAccount;
  }

  ///En Querymodel som gör ett inloggningsförsök utifrån givna parametrar.
  QueryModel.login({required this.email, required this.password}) {
    code = dbLogin;
  }

  ///En Querymodel som ger returnerar uid, email och telefonnr utifrån givna parametrar.
  QueryModel.userInfo({required this.email, required this.password}) {
    code = dbGetInfo;
  }
  QueryModel.createChannel(
      {required this.uid, required this.channelname, required this.category}) {
    code = dbCreateChannel;
  }

  QueryModel.channelOffline({required this.uid}) {
    code = dbChannelOffline;
  }

  QueryModel.getChannels() {
    code = dbGetOnlineChannels;
  }
  QueryModel.polling() {
    code = dbPing;
  }

  QueryModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        phone = json['phone'],
        password = json['password'],
        uid = json['uid'],
        code = json['code'],
        channelname = json['channelname'],
        category = json['category'],
        channelid = json['channelid'],
        isonline = json['isonline'],
        username = json['username'],
        total = json['total'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
        'password': password,
        'uid': uid,
        'code': code,
        'channelname': channelname,
        'category': category,
        'channelid': channelid,
        'isonline': isonline,
        'username': username,
        'total' : total,
      };
  @override
  String toString() {
    return "email: $email phone: $phone password: $password uid: $uid code: $code channelname: $channelname category: $category channelid: $channelid isonline: $isonline username: $username total: $total" ;
  }
}
