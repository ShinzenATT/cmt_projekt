import 'dart:async';
import 'dart:convert';

import 'package:cmt_projekt/model/query_model.dart';
import 'package:cmt_projekt/model/radio_channel.dart';
import 'package:cmt_projekt/model/stream_message.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:cmt_projekt/api/database_api.dart';

import '../constants.dart';

void main() async {
  ///En map med alla anslutna användare.
  Map<WebSocketChannel, StreamController> connectedUsers = {};

  ///En map med alla rum
  Map<String, RadioChannel> rooms = {};

  ///Instans av DatabaseApi för att möjligöra kommunikation med databasen.
  DatabaseApi database = DatabaseApi();

  ///Meddelar att en host har anslutit till ett rum och skapar detta rummet med hostens Id.
  ///Sätter även upp en extra intern ström som varje Host-websocket har enskilt för att kunna göra flera listen funktioner.
  void initHostStream(StreamMessage message, webSocket) {
    print("A new host ${message.uid} has connected: ${webSocket.hashCode}");

    ///Skapar en radiokanal.
    RadioChannel channel = RadioChannel(webSocket, message.hostId!);

    ///Lägger till radiokanalen i listan av alla radiokanaler.
    rooms[message.hostId!] = channel;

    ///Lägger till kanalen i databasen om den inte finns där. Sedan sätts den til "isOnline".
    print("ChannelName: " + message.channelName!);
    print("ChannelType: " + message.category!);

    ///
    database.sendRequest(QueryModel.createChannel(
        uid: message.uid,
        channelName: message.channelName,
        category: message.category));

    ///Sätter upp en listen funktion specifikt för en host. Denna ström låter hosten skicka meddelade till alla klienter anslutna på dennes kanal.
    ///OnDone disconnectar alla anslutna klienter till rummet och tar bort kanalen från listan
    connectedUsers[webSocket]!.stream.asBroadcastStream().listen((message) {
      if (message.runtimeType != String) {
        for (WebSocketChannel sock in channel.connectedAudioClients) {
          sendData(sock, message);
        }
      }
    }, onDone: () {
      print("host för rum ${channel.channelId} lämnade");
      for (WebSocketChannel client in channel.connectedAudioClients) {
        client.sink.close(100005, "Rum ${channel.channelId} stängdes");
      }
      print("Kanal ${channel.channelId} tas bort");
      rooms.remove(channel.channelId);
      database.sendRequest(QueryModel.channelOffline(uid: channel.channelId));
      connectedUsers.remove(webSocket);
    });
  }

  ///Meddelar att en klient har anslutit till ett rum och lägger till den till det angivna rummet.
  ///Sätter även upp en extra intern ström som varje Klient-websocket har enskilt för att kunna göra flera listen funktioner.
  void initClientStream(message, webSocket) {
    print(
        "A new client ${message.uid} has connected: ${webSocket.hashCode} and wants to join room ${message.hostId}");

    ///Plockar ut rummet som någon host har skapat ur listan av alla rum
    RadioChannel? room = rooms[message.hostId];

    ///Lägger till klienten till rummets lista av anslutna klienter.
    room!.connectedAudioClients.add(webSocket);

    ///Sätter upp en ström enbart för klienter där en onDone funktion skall disconnecta klienten.
    connectedUsers[webSocket]!.stream.asBroadcastStream().listen((event) {},
        onDone: () {
      print("Klient ${webSocket.hashCode} lämnade");
      room.disconnectAudioViewer(webSocket);
      webSocket.sink.close(10006, "lämnade servern");
      connectedUsers.remove(webSocket);
    });
  }

  var handler = webSocketHandler((WebSocketChannel webSocket) {
    ///Sätter upp så att alla klienter som ansluter får en egen StreamController och läggs till i mapen connectedUsers.
    connectedUsers[webSocket] = StreamController.broadcast();

    ///Sätter upp en listen funktion som skickar vidare all inkommande data från websocketen till StreamControllern.
    ///Ondone funktionen websocketens StreamController vilket i sin tur gör host/client stängningsmetoder.
    webSocket.stream.listen((event) {
      connectedUsers[webSocket]!.sink.add(event);
    }, onDone: () {
      connectedUsers[webSocket]!.close();
    });

    ///Sätter upp första listen funktionen till StreamControllern. Här kollas ifall den anslutna användaren är en host eller klient
    ///och sätter sedan upp rätt funktioner beroende på vad den är.
    connectedUsers[webSocket]!.stream.asBroadcastStream().listen((event) {
      if (event.runtimeType == String) {
        StreamMessage message = StreamMessage.fromJson(jsonDecode(event));
        if (message.hostOrJoin == "h" && !rooms.containsKey(message.hostId)) {
          initHostStream(message, webSocket);
        } else if (message.hostOrJoin == "j" &&
            rooms.containsKey(message.hostId)) {
          initClientStream(message, webSocket);
        } else if (message.hostOrJoin == "j" &&
            !rooms.containsKey(message.hostId)) {
          webSocket.sink.close(100009, "rummet finns inte");
        }
      }
    });
  });
  shelf_io.serve(handler, localServer, 5605).then((server) {
    print('Serving at ws://${server.address.host}:${server.port}');
  });
}

///En async funktion som sänder given data till given socket.
Future<void> sendData(WebSocketChannel client, message) async {
  print("sending");
  client.sink.add(message);
}
