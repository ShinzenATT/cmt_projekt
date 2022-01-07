///A class that contains user id, request iformation, and information about the requested radiochannel.
///The purpose of this class is to relay information between the server and client.
class StreamMessage {
  String uid;
  String? hostOrJoin;
  String? hostId;
  String channelType;
  String? channelName;
  String? category;

  ///An instance of StreamMessage for a host request.
  StreamMessage.host({
    required this.uid,
    required this.channelType,
    required this.channelName,
    required this.category,
  }) {
    hostId = uid;
    hostOrJoin = "h";
  }

  ///An instance of StreamMessage for a join request.
  StreamMessage.join(
      {required this.uid, required this.hostId, required this.channelType}) {
    hostOrJoin = "j";
  }

  ///Konverterar meddelandet till json
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'hostOrJoin': hostOrJoin,
        'hostId': hostId,
        'channelType': channelType,
        'channelName': channelName,
        'category': category,
      };

  ///Creates an instance of StreamMessage from jason.
  StreamMessage.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        hostOrJoin = json['hostOrJoin'],
        hostId = json['hostId'],
        channelType = json['channelType'],
        channelName = json['channelName'],
        category = json['category'];
}
