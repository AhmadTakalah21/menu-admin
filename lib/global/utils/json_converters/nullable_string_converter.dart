import 'package:json_annotation/json_annotation.dart';

class NullableStringConverter implements JsonConverter<String?, dynamic> {
  const NullableStringConverter();

  @override
  String? fromJson(dynamic json) => json?.toString();

  @override
  dynamic toJson(String? object) => object;
}
