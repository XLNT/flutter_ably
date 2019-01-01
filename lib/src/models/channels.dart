import 'package:rxdart/rxdart.dart';

import '../utils/filters.dart';

import './client.dart';
import './realtime_channel.dart';

import '../packets/message_packet.dart';
import '../packets/channel_state_change_packet.dart';

class Channels {
  Client client;
  Observable<MessagePacket> messagePackets;
  Observable<ChannelStateChangePacket> channelStateChangePackets;

  Channels({
    this.client,
    this.messagePackets,
    this.channelStateChangePackets,
  });

  Future<RealtimeChannel> get(String id) async {
    final messages = messagePackets //
        .where(channelIs(id))
        .map((em) => em.message)
        .share();
    final stateChange = channelStateChangePackets //
        .where(channelIs(id))
        .map((esc) => esc.stateChange)
        .share();
    final state = stateChange //
        .map((s) => s.current)
        .shareValue();

    return RealtimeChannel(
      id: id,
      client: client,
      messages: messages,
      stateChange: stateChange,
      state: state,
    );
  }
}
