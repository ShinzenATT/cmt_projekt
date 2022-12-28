import 'package:cmt_projekt/models/channel_data_model.dart';

///A class that contains user id, request iformation, and information about the requested radiochannel.
///The purpose of this class is to relay information between the server and client.
class StreamMessage {
  /// the uuid of the user that makes the request
  String uid;
  /// the intent of the request, for example `h` is to host a stream,
  /// `j` is to join a stream and `u` to update channel info.
  String? intent;
  /// the uuid of the target channel that the client wants to join to or host as
  String? hostId;
  /// the stream type the message concerns, such as `a` for audio stream
  String channelType;
  /// The channel data to upload to the db in a host/update msg
  ChannelDataModel? channelData;

  ///An instance of [StreamMessage] for a host request.
  StreamMessage.host({
    required this.channelType,
    required this.channelData
  }):
    uid = channelData!.channelid,
    hostId = channelData.channelid,
    intent = "h";

  ///An instance of [StreamMessage] for a join request.
  StreamMessage.join({
    required this.uid,
    required this.hostId,
    required this.channelType}) {
    intent = "j";
  }

  /// Creates an instance of [StreamMessage] for a update request
  StreamMessage.update({
    required this.channelData,
    required this.channelType
}):
    uid = channelData!.channelid,
    hostId = channelData.channelid,
    intent = "u";

  /// Converts the object to a map with string keys
  Map<String, dynamic> toMap() => {
        'uid': uid,
        'intent': intent,
        'host_id': hostId,
        'channel_type': channelType,
        'channel_data': channelData?.toMap()
      };

  ///Creates an instance of StreamMessage from a Map with String keys.
  StreamMessage.parseMap(Map<String, dynamic> json)
      : uid = json['uid'],
        intent = json['intent'],
        hostId = json['host_id'],
        channelType = json['channel_type'],
        channelData = json['channel_data'] != null ? ChannelDataModel.parseMap(json['channel_data']): null;
}
