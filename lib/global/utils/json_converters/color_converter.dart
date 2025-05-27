import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorConverter implements JsonConverter<Color?, dynamic> {
  const ColorConverter();

  @override
  Color? fromJson(dynamic json) {
    if (json == null || json == "null") {
      return null;
    }
    final hex = int.tryParse(json.substring(6, 16));
    if (hex == null) {
      return null;
    }
    return Color(hex);
  }

  @override
  dynamic toJson(Color? object) => "$object";
}
