import 'package:web_socket_channel/web_socket_channel.dart';

/// A data class used by the Stream server to keep track of connected clients and hosts
class RadioChannel {
  /// user ID of the host
  late final String channelId;

  /// The websocket for the host user's audio stream
  late final WebSocketChannel streamAudioHost;
  /// The websocket for the host user's video stream
  late final WebSocketChannel streamVideoHost;
  /// A list of audio clients listening to the host
  final List<WebSocketChannel> connectedAudioClients = List.empty(growable: true);
  /// A list of video clients watching the host
  final List<WebSocketChannel> connectedVideoClients = List.empty(growable: true);

  /// creates a [RadioChannel] channel room and takes control of the websocket connected to the host
  RadioChannel(WebSocketChannel wc, String channel) {
    channelId = channel;
    streamAudioHost = wc;
    //print("room: $channel created");
  }

  /// Adds a client websocket to the listener list
  addAudioViewer(WebSocketChannel wc) {
    if (!connectedAudioClients.contains(wc)) {
      connectedAudioClients.add(wc);
    }
  }

  /// Removes a client from the listener list
  disconnectAudioViewer(WebSocketChannel wc) {
    if (connectedAudioClients.contains(wc)) {
      connectedAudioClients.remove(wc);
    }
  }
}
