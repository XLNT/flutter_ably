import './channel_state.dart';

class ClientChannelState {
  String clientId;
  String channelId;

  ChannelState state;

  ClientChannelState({
    this.clientId,
    this.channelId,
    this.state,
  });
}
