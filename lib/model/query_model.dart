import 'package:cmt_projekt/constants.dart';

class QueryModel {
  String? email;
  String? phone;
  String? password;
  String? uid;
  String? channelid;
  String? code;
  String? channelName;
  String? category;
  bool? isonline;

  ///En Querymodel som försöker skapa ett konto utifrån givna parametrar.
  QueryModel.account(
      {required this.email, required this.phone, required this.password}) {
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
      {required this.uid, required this.channelName, required this.category}) {
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
        channelName = json['channelname'],
        category = json['category'],
        channelid = json['channelid'],
        isonline = json['isonline'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
        'password': password,
        'uid': uid,
        'code': code,
        'channelName': channelName,
        'category': category,
        'channelid': channelid,
        'isonline': isonline,
      };
  @override
  String toString() {
    return "email: $email phone: $phone password: $password uid: $uid code: $code channelName: $channelName category: $category channelid: $channelid isonline: $isonline";
  }
}
