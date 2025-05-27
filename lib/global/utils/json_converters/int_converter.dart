import 'package:json_annotation/json_annotation.dart';

class NullableIntConverter implements JsonConverter<int?, dynamic> {
  const NullableIntConverter();

  @override
  int? fromJson(dynamic json) => int.tryParse(json.toString());

  @override
  dynamic toJson(int? object) => object?.toString();
}

class IntConverter implements JsonConverter<int, dynamic> {
  const IntConverter();

  @override
  int fromJson(dynamic json) => int.parse(json.toString());

  @override
  dynamic toJson(int object) => object.toString();
}
