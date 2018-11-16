import './envelope_message.dart';
import './channel_state_change.dart';

class EnvelopeChannelStateChange implements EnvelopeMessage {
  String clientId;
  String channelId;

  ChannelStateChange stateChange;

  EnvelopeChannelStateChange({
    this.clientId,
    this.channelId,
    this.stateChange,
  });
}
