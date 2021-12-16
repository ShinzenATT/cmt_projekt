///En klass som innehåller id,förfrågningsinfo och kanalinfo.
///Syftet med denna klass är att skapa en enkel kommunikation mellan server och klient.
class StreamMessage {
  String uid;
  String? hostOrJoin;
  String? hostId;
  String channelType;
  String? channelName;
  String? category;

  ///Ett StreamMessage skapar en förfrågan att hosta.
  StreamMessage.host({
    required this.uid,
    required this.channelType,
    required this.channelName,
    required this.category,
  }) {
    hostId = uid;
    hostOrJoin = "h";
  }

  ///Ett StreamMessage skapar en förfrågan att joina.
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

  ///Skapar en klass från json.
  StreamMessage.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        hostOrJoin = json['hostOrJoin'],
        hostId = json['hostId'],
        channelType = json['channelType'],
        channelName = json['channelName'],
        category = json['category'];
}
