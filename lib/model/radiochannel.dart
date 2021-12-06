import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

class RadioChannel {
  //user ID of the host
  late final String channelId;

  late final StreamController streamAudioHost;
  late final WebSocketChannel streamVideoHost;
  final List<WebSocketChannel> connectedAudioClients = List.empty(growable: true);
  final List<WebSocketChannel> connectedVideoClients = List.empty(growable: true);
  RadioChannel(StreamController wc, String channel) {
    channelId = channel;
    streamAudioHost = wc;
    streamAudioHost.stream.asBroadcastStream().listen((message) {
      for (WebSocketChannel sock in connectedAudioClients) {
        sendData(sock, message);
      }
    });
    print("room: $channel created");
  }

  addAudioViewer(WebSocketChannel wc) {
    if (!connectedAudioClients.contains(wc)) {
      connectedAudioClients.add(wc);
    }
  }

  addVideoViewer(WebSocketChannel wc) {
    if (!connectedVideoClients.contains(wc)) {
      connectedVideoClients.add(wc);
    }
  }

  disconnectAudioViewer(WebSocketChannel wc) {
    if (connectedAudioClients.contains(wc)) {
      connectedAudioClients.remove(wc);
    }
  }

  disconnectVideoViewer(WebSocketChannel wc) {
    if (connectedVideoClients.contains(wc)) {
      connectedVideoClients.remove(wc);
    }
  }

  startHosting(){
  return channelId;
  }

  Future<void> sendData(WebSocketChannel client, message) async {
    client.sink.add(message);
  }

  //Probably needs more
  stopHosting() {
    print('Maybe implement in future');
  }
}
