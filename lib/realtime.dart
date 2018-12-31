import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';

import './utils/referenceable.dart';

import './client.dart';
import './envelope_channel_state_change.dart';
import './envelope_channel_message.dart';
import './channels.dart';

class Realtime extends Referenceable implements Client {
  final String id;
  final String token;
  final MethodChannel channel;
  Channels channels;

  Realtime({
    this.id,
    this.token,
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

  Future<void> setup() async {
    await channel.invokeMethod('Realtime#new', {
      'token': token,
      'clientId': id,
    });
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
    await channel.invokeMethod('Realtime#dispose', {
      'clientId': id,
    });
  }
}
