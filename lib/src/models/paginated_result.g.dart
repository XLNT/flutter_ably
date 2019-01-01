// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginatedResult<T> _$PaginatedResultFromJson<T>(Map json) {
  return PaginatedResult<T>(
      hasNext: json['hasNext'] as bool,
      items: (json['items'] as List)
          ?.map((e) => e == null ? null : _Converter<T>().fromJson(e))
          ?.toList());
}

Map<String, dynamic> _$PaginatedResultToJson<T>(PaginatedResult<T> instance) =>
    <String, dynamic>{
      'hasNext': instance.hasNext,
      'items': instance.items
          ?.map((e) => e == null ? null : _Converter<T>().toJson(e))
          ?.toList()
    };
