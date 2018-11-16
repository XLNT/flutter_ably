import './channel_state.dart';

class ChannelStateChange {
  ChannelState current;
  ChannelState previous;
  bool resumed;

  ChannelStateChange({
    this.current,
    this.previous,
    this.resumed,
  });
}
