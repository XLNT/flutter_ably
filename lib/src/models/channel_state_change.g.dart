// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_state_change.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelStateChange _$ChannelStateChangeFromJson(Map json) {
  return ChannelStateChange(
      current: _$enumDecodeNullable(_$ChannelStateEnumMap, json['current']),
      previous: _$enumDecodeNullable(_$ChannelStateEnumMap, json['previous']),
      resumed: json['resumed'] as bool);
}

Map<String, dynamic> _$ChannelStateChangeToJson(ChannelStateChange instance) =>
    <String, dynamic>{
      'current': _$ChannelStateEnumMap[instance.current],
      'previous': _$ChannelStateEnumMap[instance.previous],
      'resumed': instance.resumed
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$ChannelStateEnumMap = <ChannelState, dynamic>{
  ChannelState.INITIALIZED: 'INITIALIZED',
  ChannelState.ATTACHING: 'ATTACHING',
  ChannelState.ATTACHED: 'ATTACHED',
  ChannelState.DETACHING: 'DETACHING',
  ChannelState.DETACHED: 'DETACHED',
  ChannelState.SUSPENDED: 'SUSPENDED',
  ChannelState.FAILED: 'FAILED'
};
