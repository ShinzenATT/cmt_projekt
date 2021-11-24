class StreamMessage{
  String uid;
  late String hostOrJoin;
  late String hostId;
  String channelType;

  StreamMessage.host({required this.uid,required this.channelType}){
    hostId = uid;
    hostOrJoin = "h";
  }
  StreamMessage.join({required this.uid,required this.hostId,required this.channelType}){
    hostOrJoin = "j";
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'hostOrJoin': hostOrJoin,
    'hostId': hostId,
    'channelType': channelType,
  };

  StreamMessage.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        hostOrJoin = json['hostOrJoin'],
        hostId = json['hostId'],
        channelType = json['channelType'];
}