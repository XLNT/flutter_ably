import 'package:rxdart/rxdart.dart';

import './client.dart';

import './realtime_channel.dart';

import './envelope_message.dart';
import './envelope_channel_message.dart';
import './envelope_channel_state_change.dart';

bool Function(EnvelopeMessage) channelIs(String channelId) =>
    (EnvelopeMessage message) => message.channelId == channelId;

class Channels {
  Client client;
  Observable<EnvelopeChannelMessage> allChannelMessages;
  Observable<EnvelopeChannelStateChange> allChannelStateChanges;

  Channels({
    this.client,
    this.allChannelMessages,
    this.allChannelStateChanges,
  });

  Future<RealtimeChannel> get(String id) async {
    // @TODO - create a new stream and addStream and allow this other stream to be closed on unsubscribe
    final messages = allChannelMessages.where(channelIs(id)).map((em) => em.message);
    final stateChange = allChannelStateChanges.where(channelIs(id)).map((esc) => esc.stateChange);
    final state = stateChange.map((s) => s.current).shareValue();

    return RealtimeChannel(
      id: id,
      client: client,
      messages: messages,
      stateChange: stateChange,
      state: state,
    );
  }
}
