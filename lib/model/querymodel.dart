class QueryModel {
  late String email;
  late String phone;
  late String password;
  late String uid;
  final String code;
  QueryModel(
      {required this.code,required this.email, required this.phone, required this.password}){
    uid = "";
  }
  QueryModel.login({required this.code,required this.email, required this.password}) {
    phone = "";
    uid = "";
  }

  QueryModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        phone = json['phone'],
        password = json['password'],
        uid = json['uid'],
        code = json['code'];

  QueryModel.fromJsonLogin(Map<String, dynamic> json)
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

  bool isAccountCreation() {
    if (email.isNotEmpty && phone.isNotEmpty && password.isNotEmpty) {
      return true;
    }
    return false;
  }
}
