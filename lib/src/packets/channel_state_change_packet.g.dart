// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_state_change_packet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelStateChangePacket _$ChannelStateChangePacketFromJson(Map json) {
  return ChannelStateChangePacket(
      clientId: json['clientId'] as String,
      channelId: json['channelId'] as String,
      stateChange: json['stateChange'] == null
          ? null
          : ChannelStateChange.fromJson(json['stateChange'] as Map));
}

Map<String, dynamic> _$ChannelStateChangePacketToJson(
        ChannelStateChangePacket instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'channelId': instance.channelId,
      'stateChange': instance.stateChange
    };
