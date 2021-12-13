import 'package:web_socket_channel/web_socket_channel.dart';

class RadioChannel {
  //user ID of the host
  late final String channelId;

  late final WebSocketChannel streamAudioHost;
  late final WebSocketChannel streamVideoHost;
  final List<WebSocketChannel> connectedAudioClients = List.empty(growable: true);
  final List<WebSocketChannel> connectedVideoClients = List.empty(growable: true);
  RadioChannel(WebSocketChannel wc, String channel) {
    channelId = channel;
    streamAudioHost = wc;
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

  //Probably needs more
  stopHosting() {
    print('Maybe implement in future');
  }
}
