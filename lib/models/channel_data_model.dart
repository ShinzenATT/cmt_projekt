import 'package:cmt_projekt/environment.dart';

/// A data class that houses most relevant channal data
class ChannelDataModel {
  /// The user's uid
  String channelid;
  /// the channel title
  String channelname;
  /// the channel content category
  String category;
  /// the user's username
  String username;
  /// the channel description (may be overriden by timetable descriptions)
  String? description;
  /// an boolean that indicates if the channel is online and streaming
  bool isonline;
  /// the number of listeners/viewers to an active stream
  int total;
  /// the url to the user's profile image
  Uri? profileImageUrl;
  /// the url to the stream image/banner
  Uri? channelImageUrl;
  /// A list of upcoming streams described as a timetable
  List<TimetableEntry> timetable;

  /// creates a channel model instance
  ChannelDataModel({
      required this.channelid,
      required this.channelname,
      required this.category,
      this.username = "",
      this.isonline = true,
      this.total = 0,
      this.description,
      String? profileImageUrl,
      String? channelImageUrl,
      this.timetable = const []
  }):
        profileImageUrl = (profileImageUrl != null ? Uri.http(localServer, profileImageUrl): null),
        channelImageUrl = (channelImageUrl != null ? Uri.http(localServer, channelImageUrl): null)
  ;

  /// creates a channel model from a [Map<String, dynamic>]
  factory ChannelDataModel.parseMap(Map<String, dynamic> map){
    return ChannelDataModel(
        channelid: map['channelid'],
        channelname: map['channelname'],
        category: map['category'],
        username: map['username'] ?? '',
        isonline: map['isonline'] ?? true,
        total: map['total'] ?? 0,
        description: map['description'],
        profileImageUrl: map['profileimageurl'],
        channelImageUrl: map['imageurl'],
        timetable: (map['timetable'] as List? ?? []).map((element) => TimetableEntry.parseMap(element)).toList()
    );
  }

  /// converts the object to a [Map<String, dynamic>] to be more serializable
  Map<String, dynamic> toMap(){
    return {
      'channelid': channelid,
      'channelname': channelname,
      'category': category,
      'username': username,
      'isonline': isonline,
      'total': total,
      'description': description,
      'profileimageurl': profileImageUrl?.path,
      'imageurl': channelImageUrl?.path,
      'timetable': timetable.map((e) => e.toMap()).toList()
    };
  }
}

/// A class that represents a row in a timetable
class TimetableEntry {
  /// the user's/channel's uid that the entry is connected to
  String channel;
  /// the start timestamp of the event
  DateTime startTime;
  /// an optional end timestamp of the event
  DateTime? endTime;
  /// an optional description of the event
  String? description;

  /// creates a timetable entry
  TimetableEntry({
    required this.channel,
    required this.startTime,
    this.endTime,
    this.description
  });

  /// creates a timetable entry whilst parsing string timestamps
  TimetableEntry.parseStringTimes({
    required this.channel,
    this.description,
    required String startTime,
    String? endTime,
  }):
      startTime = DateTime.parse(startTime),
      endTime = (endTime != null? DateTime.parse(endTime): null);

  /// creates a timetable entry by parsing a [Map<String, dynamic>]
  factory TimetableEntry.parseMap(Map<String, dynamic> map){
    return TimetableEntry.parseStringTimes(
        channel: map['channel'],
        startTime: map['starttime'],
        endTime: map['endtime'],
        description: map['description']
      );
    }

  /// Converts the object to a [Map<String, dynamic>] to make more serializable
  Map<String, String?> toMap() {
    return {
      'channel': channel,
      'starttime': startTime.toString(),
      'endtime': endTime?.toString(),
      'description': description
      };
    }
  }
