import './envelope_message.dart';
import './channel_message.dart';

class EnvelopeChannelMessage implements EnvelopeMessage {
  String clientId;
  String channelId;
  ChannelMessage message;

  EnvelopeChannelMessage({
    this.clientId,
    this.channelId,
    this.message,
  });
}
