import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorConverter implements JsonConverter<Color, dynamic> {
  const ColorConverter();

  @override
  Color fromJson(dynamic json) {
    try {
      if (json is String && json.startsWith('Color(')) {
        final hex = json.replaceAll('Color(', '').replaceAll(')', '');
        return Color(int.parse(hex));
      }
    } catch (_) {}
    return Colors.transparent;
  }

  @override
  dynamic toJson(Color object) => 'Color(0x${object.value.toRadixString(16).padLeft(8, '0')})';
}