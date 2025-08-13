import 'package:json_annotation/json_annotation.dart';

class BoolNumConverter implements JsonConverter<bool?, dynamic> {
  const BoolNumConverter();

  @override
  bool? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is bool) return json;
    if (json is num) return json != 0;
    if (json is String) {
      final s = json.trim().toLowerCase();
      if (s == '1' || s == 'true') return true;
      if (s == '0' || s == 'false') return false;
    }
    return null;
  }

  @override
  dynamic toJson(bool? value) => value == null ? null : (value ? 1 : 0);
}
