import 'package:json_annotation/json_annotation.dart';

import './channel_state.dart';

part 'channel_state_change.g.dart';

@JsonSerializable()
class ChannelStateChange {
  ChannelState current;
  ChannelState previous;
  bool resumed;

  ChannelStateChange({
    this.current,
    this.previous,
    this.resumed,
  });

  factory ChannelStateChange.fromJson(Map json) => _$ChannelStateChangeFromJson(json);
  Map<String, dynamic> toJson() => _$ChannelStateChangeToJson(this);
}
