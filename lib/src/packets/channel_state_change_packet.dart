import 'package:json_annotation/json_annotation.dart';

import './packet.dart';
import '../models/channel_state_change.dart';

part 'channel_state_change_packet.g.dart';

@JsonSerializable()
class ChannelStateChangePacket implements Packet {
  String clientId;
  String channelId;

  ChannelStateChange stateChange;

  ChannelStateChangePacket({
    this.clientId,
    this.channelId,
    this.stateChange,
  });

  factory ChannelStateChangePacket.fromJson(Map json) => _$ChannelStateChangePacketFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelStateChangePacketToJson(this);
}
