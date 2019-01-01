import 'package:json_annotation/json_annotation.dart';

import './message.dart';

part 'paginated_result.g.dart';

@JsonSerializable()
class PaginatedResult<T> {
  bool hasNext;

  @_Converter()
  List<T> items;

  PaginatedResult({
    this.hasNext,
    this.items,
  });

  factory PaginatedResult.fromJson(Map json) => _$PaginatedResultFromJson(json);
  Map<String, dynamic> toJson() => _$PaginatedResultToJson(this);
}

class _Converter<T> implements JsonConverter<T, Object> {
  const _Converter();

  @override
  T fromJson(Object json) {
    Message.fromJson(Map<String, dynamic>.from(json)) as T

    // TODO support all PaginatedResult generic types

    // This will only work if `json` is a native JSON type:
    //   num, String, bool, null, etc
    // *and* is assignable to `T`.
    return json as T;
  }

  @override
  Object toJson(T object) {
    // This will only work if `object` is a native JSON type:
    //   num, String, bool, null, etc
    // Or if it has a `toJson()` function`.
    return object;
  }
}
