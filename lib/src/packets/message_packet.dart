import 'package:json_annotation/json_annotation.dart';

import './packet.dart';
import '../models/message.dart';

part 'message_packet.g.dart';

@JsonSerializable()
class MessagePacket implements Packet {
  String clientId;
  String channelId;
  Message message;

  MessagePacket({
    this.clientId,
    this.channelId,
    this.message,
  });

  factory MessagePacket.fromJson(Map json) {
    json['message'] = Map<String, dynamic>.from(json['message']);
    return _$MessagePacketFromJson(json);
  }
  Map<String, dynamic> toJson() => _$MessagePacketToJson(this);
}
