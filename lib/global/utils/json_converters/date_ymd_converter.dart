import 'package:json_annotation/json_annotation.dart';

class DateYMDConverter implements JsonConverter<DateTime?, dynamic> {
  const DateYMDConverter();

  @override
  DateTime? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is String && json.isNotEmpty) {
      return DateTime.tryParse(json);
    }
    return null;
  }

  @override
  dynamic toJson(DateTime? value) =>
      value?.toIso8601String().substring(0, 10);
}
