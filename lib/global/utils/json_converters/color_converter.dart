import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorConverter implements JsonConverter<Color?, dynamic> {
  const ColorConverter();

  @override
  Color? fromJson(dynamic json) {
    if (json == null) return null;

    if (json is int) return Color(json);

    if (json is String) {
      final s = json.trim();
      if (s.isEmpty || s.toLowerCase() == 'null') return null;

      final m = RegExp(r'Color\(\s*0x([0-9a-fA-F]{8})\s*\)').firstMatch(s);
      if (m != null) return Color(int.parse('0x${m.group(1)!}'));

      if (RegExp(r'^(0x)?[0-9a-fA-F]{8}$').hasMatch(s)) {
        final v = int.parse(s.startsWith('0x') ? s : '0x$s');
        return Color(v);
      }

      if (s.startsWith('#')) {
        final hex = s.substring(1);
        if (hex.length == 6) return Color(int.parse('0xff$hex'));
        if (hex.length == 8) return Color(int.parse('0x$hex'));
      }
    }

    return null;
  }

  @override
  dynamic toJson(Color? color) => color?.value;
}
