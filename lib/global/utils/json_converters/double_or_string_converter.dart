import 'package:json_annotation/json_annotation.dart';

class DoubleOrStringConverter implements JsonConverter<double?, dynamic> {
  const DoubleOrStringConverter();

  @override
  double? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is num) return json.toDouble();
    if (json is String) return double.tryParse(json.trim());
    return null;
  }

  @override
  dynamic toJson(double? value) => value;
}
