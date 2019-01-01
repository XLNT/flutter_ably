import 'package:json_annotation/json_annotation.dart';

part 'realtime_history_query.g.dart';

@JsonSerializable()
class RealtimeHistoryQuery {
  DateTime start;
  DateTime end;
  int direction;
  int limit;
  bool untilAttach;

  RealtimeHistoryQuery({
    this.start,
    this.end,
    this.direction,
    this.limit,
    this.untilAttach,
  });

  factory RealtimeHistoryQuery.fromJson(Map json) => _$RealtimeHistoryQueryFromJson(json);
  Map<String, dynamic> toJson() => _$RealtimeHistoryQueryToJson(this);
}
