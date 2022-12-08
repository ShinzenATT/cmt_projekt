class ChannelDataModel {
  String channelid;
  String channelname;
  String category;
  String username;
  String? description;
  bool isonline;
  int total;
  List<TimetableEntry> timetable;

  ChannelDataModel({
      required this.channelid,
      required this.channelname,
      required this.category,
      this.username = "",
      this.isonline = true,
      this.total = 0,
      this.description,
      this.timetable = const []
  });

  factory ChannelDataModel.parseMap(Map<String, dynamic> map){
    return ChannelDataModel(
        channelid: map['channelid'],
        channelname: map['channelname'],
        category: map['category'],
        username: map['username'],
        isonline: map['isonline'],
        total: map['total'],
        description: map['description'],
        timetable: (map['timetable'] as List).map((element) => TimetableEntry.parseMap(element)).toList()
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'channelid': channelid,
      'channelname': channelname,
      'category': category,
      'username': username,
      'isonline': isonline,
      'total': total,
      'description': description,
      'timetable': timetable.map((e) => e.toMap()).toList()
    };
  }
}

class TimetableEntry {
  String channel;
  DateTime startTime;
  DateTime? endTime;
  String? description;

  TimetableEntry({
    required this.channel,
    required this.startTime,
    this.endTime,
    this.description
  });

  TimetableEntry.parseStringTimes({
    required this.channel,
    this.description,
    required String startTime,
    String? endTime,
  }):
      startTime = DateTime.parse(startTime),
      endTime = (endTime != null? DateTime.parse(endTime): null);

  factory TimetableEntry.parseMap(Map<String, dynamic> map){
    return TimetableEntry.parseStringTimes(
        channel: map['channel'],
        startTime: map['starttime'],
        endTime: map['endtime'],
        description: map['description']
      );
    }

  Map<String, String?> toMap() {
    return {
      'channel': channel,
      'starttime': startTime.toString(),
      'endtime': endTime?.toString(),
      'description': description
      };
    }
  }