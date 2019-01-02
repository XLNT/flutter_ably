// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map json) {
  return Message(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      connectionId: json['connectionId'] as String,
      timestamp: json['timestamp'] as int,
      encoding: json['encoding'] as String,
      data: json['data'] as String,
      name: json['name'] as String);
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'connectionId': instance.connectionId,
      'timestamp': instance.timestamp,
      'encoding': instance.encoding,
      'data': instance.data,
      'name': instance.name
    };
