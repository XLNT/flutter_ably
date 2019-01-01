// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_packet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessagePacket _$MessagePacketFromJson(Map json) {
  return MessagePacket(
      clientId: json['clientId'] as String,
      channelId: json['channelId'] as String,
      message: json['message'] == null
          ? null
          : Message.fromJson(json['message'] as Map));
}

Map<String, dynamic> _$MessagePacketToJson(MessagePacket instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'channelId': instance.channelId,
      'message': instance.message
    };
