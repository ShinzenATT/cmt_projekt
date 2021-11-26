///En klass som innehåller id,förfrågningsinfo och kanalinfo.
///Syftet med denna klass är att skapa en enkel kommunikation mellan server och klient.
class StreamMessage{
  String uid;
  late String hostOrJoin;
  late String hostId;
  String channelType;
  ///Ett StreamMessage skapar en förfrågan att hosta.
  StreamMessage.host({required this.uid,required this.channelType}){
    hostId = uid;
    hostOrJoin = "h";
  }
  ///Ett StreamMessage skapar en förfrågan att joina.
  StreamMessage.join({required this.uid,required this.hostId,required this.channelType}){
    hostOrJoin = "j";
  }
  ///Konverterar meddelandet till json
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'hostOrJoin': hostOrJoin,
    'hostId': hostId,
    'channelType': channelType,
  };
  ///Skapar en klass från json.
  StreamMessage.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        hostOrJoin = json['hostOrJoin'],
        hostId = json['hostId'],
        channelType = json['channelType'];
}