// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realtime_history_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RealtimeHistoryQuery _$RealtimeHistoryQueryFromJson(Map json) {
  return RealtimeHistoryQuery(
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String),
      direction: json['direction'] as int,
      limit: json['limit'] as int,
      untilAttach: json['untilAttach'] as bool);
}

Map<String, dynamic> _$RealtimeHistoryQueryToJson(
        RealtimeHistoryQuery instance) =>
    <String, dynamic>{
      'start': instance.start?.toIso8601String(),
      'end': instance.end?.toIso8601String(),
      'direction': instance.direction,
      'limit': instance.limit,
      'untilAttach': instance.untilAttach
    };
