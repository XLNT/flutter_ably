import './channel_message.dart';

class ClientMessage {
  String clientId;
  String channelId;
  ChannelMessage message;

  ClientMessage({
    this.clientId,
    this.channelId,
    this.message,
  });
}
