import 'package:cmt_projekt/constants.dart';

class QueryModel {
  late String email;
  late String phone;
  late String password;
  late String uid;
  late String code;

  ///En Querymodel som försöker skapa ett konto utifrån givna parametrar.
  QueryModel.account(
      {required this.email, required this.phone, required this.password}){
    uid = "";
    code = dbAccount;
  }
  ///En Querymodel som gör ett inloggningsförsök utifrån givna parametrar.
  QueryModel.login({required this.email, required this.password}) {
    phone = "";
    uid = "";
    code = dbLogin;
  }

  ///En Querymodel som ger returnerar uid, email och telefonnr utifrån givna parametrar.
  QueryModel.userInfo({required this.email, required this.password}) {
    phone = "";
    uid = "";
    code = dbGetInfo;
  }

  QueryModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        phone = json['phone'],
        password = json['password'],
        uid = json['uid'],
        code = json['code'];

  QueryModel.fromJsonUserinfo(Map<String, dynamic> json)
      : email = json['email'],
        phone = json['phone'],
        password = "",
        uid = json['uid'],
        code = "";

  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
        'password': password,
        'uid': uid,
        'code': code,
      };
  @override
  String toString() {
    return "email: $email phone: $phone password: $password";
  }
}
