/// A generic data class for carrying any to no properties related to account and channels.
/// Note: it's a legacy class
class QueryModel {
  /// the user's email
  String? email;
  /// The user's phone number
  String? phone;
  /// the user's password
  String? password;
  /// the user's uuid
  String? uid;
  /// the channel uuid that is desired to be watched/interacted with
  String? channelid;
  /// the name of the channel
  String? channelname;
  /// the category of the channel
  String? category;
  /// the username of the user
  String? username;
  /// a bool indicating if the channel is online
  bool? isonline;
  /// the amount of listeners on the active channel
  int? total;

  /// constructor that requires params related to adding/removing viewers
  QueryModel.handleViewers({required this.channelid, required this.uid});

  /// constructor that requires params for clearing al viewers of a channel
  QueryModel.delViewers({required this.channelid});

  /// constructor that requires params for account creation
  QueryModel.account(
      {required this.email,
      required this.phone,
      required this.password,
      required this.username});

  /// constructor that requires params for login (Note that email can also contain the phonenumber)
  QueryModel.login({required this.email, required this.password});

  /// constructor that requires params for creating/updating a channel
  QueryModel.createChannel({required this.uid, required this.channelname, required this.category});

  /// constructor that requires params for making a channel offline
  QueryModel.channelOffline({required this.uid});

  /// parses a [Map<String, dynamic>]
  QueryModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        phone = json['phone'],
        password = json['password'],
        uid = json['uid'],
        channelname = json['channelname'],
        category = json['category'],
        channelid = json['channelid'],
        isonline = json['isonline'],
        username = json['username'],
        total = json['total'];

  /// converts the object to a [Map<String, dynamic>]
  Map<String, dynamic> toJson() => {
        'email': email,
        'phone': phone,
        'password': password,
        'uid': uid,
        'channelname': channelname,
        'category': category,
        'channelid': channelid,
        'isonline': isonline,
        'username': username,
        'total' : total,
      };

  @override
  String toString() {
    return "email: $email phone: $phone password: $password uid: $uid channelname: $channelname category: $category channelid: $channelid isonline: $isonline username: $username total: $total" ;
  }
}
