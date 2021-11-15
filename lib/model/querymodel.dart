class QueryModel {
  final String email;
  late String phone;
  final String password;
  QueryModel(
      {required this.email, required this.phone, required this.password});
  QueryModel.login({required this.email, required this.password}) {
    phone = "";
  }

  QueryModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        phone = json['phone'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
        'password': password,
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
