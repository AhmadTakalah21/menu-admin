import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'permission_model.g.dart';

@JsonSerializable()
@immutable
class PermissionModel {
  const PermissionModel(this.name);

  final String name;

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      _$PermissionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PermissionModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory PermissionModel.fromString(String jsonString) {
    return PermissionModel.fromJson(json.decode(jsonString));
  }
}
