import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';

import '../utils/referenceable.dart';

import './client.dart';
import './channels.dart';
import '../packets/message_packet.dart';
import '../packets/channel_state_change_packet.dart';

class Realtime extends Referenceable implements Client {
  final String id;
  final MethodChannel channel;
  Channels channels;

  Realtime({
    this.id,
    this.channel,
    Observable<MessagePacket> messagePackets,
    Observable<ChannelStateChangePacket> channelStateChangePackets,
  }) {
    channels = Channels(
      client: this,
      messagePackets: messagePackets,
      channelStateChangePackets: channelStateChangePackets,
    );
  }

  Future<void> setup(String token) async {
    await _call('new', {
      'token': token,
    });
  }

  Future<void> authorize(String token) async {
    await _call('authorize', {
      'token': token,
    });
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
    await _call('dispose');
  }

  Future<dynamic> _call(
    String methodName, [
    Map<String, dynamic> args = const {},
  ]) async {
    final Map<String, dynamic> baseArgs = {
      "clientId": id,
    };

    return channel.invokeMethod(
      "Realtime#$methodName",
      baseArgs..addAll(args),
    );
  }
}
