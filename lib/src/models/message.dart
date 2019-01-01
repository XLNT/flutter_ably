import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';

@JsonSerializable()
class Message {
  String id;
  String clientId;
  String connectionId;
  String timestamp;
  String encoding;
  String data;
  String name;

  Message({
    this.id,
    this.clientId,
    this.connectionId,
    this.timestamp,
    this.encoding,
    this.data,
    this.name,
  });

  factory Message.fromJson(Map json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
