import 'package:cmt_projekt/models/channel_data_model.dart';

///A class that contains user id, request iformation, and information about the requested radiochannel.
///The purpose of this class is to relay information between the server and client.
class StreamMessage {
  String uid;
  String? intent;
  String? hostId;
  String channelType;
  ChannelDataModel? channelData;

  ///An instance of StreamMessage for a host request.
  StreamMessage.host({
    required this.uid,
    required this.channelType,
    required this.channelData
  }) {
    hostId = uid;
    intent = "h";
  }

  ///An instance of StreamMessage for a join request.
  StreamMessage.join({
    required this.uid,
    required this.hostId,
    required this.channelType}) {
    intent = "j";
  }

  StreamMessage.update({
    required this.channelData,
    required this.channelType,
    required this.uid
}){
    hostId = uid;
    intent = "u";
}

  ///Konverterar meddelandet till en map med string keys
  Map<String, dynamic> toMap() => {
        'uid': uid,
        'intent': intent,
        'hostId': hostId,
        'channel_type': channelType,
        'channel_data': channelData?.toMap()
      };

  ///Creates an instance of StreamMessage from a Map with String keys.
  StreamMessage.parseMap(Map<String, dynamic> json)
      : uid = json['uid'],
        intent = json['intent'],
        hostId = json['hostId'],
        channelType = json['channelType'],
        channelData = json['channel_data'] != null ? ChannelDataModel.parseMap(json['channel_data']): null;
}
