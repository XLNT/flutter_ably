import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';

import './client.dart';
import './envelope_channel_state_change.dart';
import './envelope_channel_message.dart';
import './channels.dart';

class Realtime implements Client {
  // public
  final String id;
  final MethodChannel channel;
  Channels channels;

  Realtime({
    this.id,
    this.channel,
    Observable<EnvelopeChannelMessage> allChannelMessages,
    Observable<EnvelopeChannelStateChange> allChannelStateChanges,
  }) {
    channels = Channels(
      client: this,
      allChannelMessages: allChannelMessages,
      allChannelStateChanges: allChannelStateChanges,
    );
  }
}
