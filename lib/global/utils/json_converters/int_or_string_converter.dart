import 'package:json_annotation/json_annotation.dart';

class IntOrStringConverter implements JsonConverter<int?, dynamic> {
  const IntOrStringConverter();

  @override
  int? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is int) return json;
    if (json is String) return int.tryParse(json.trim());
    return null;
  }

  @override
  dynamic toJson(int? value) => value;
}
