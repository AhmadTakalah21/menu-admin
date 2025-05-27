import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_admin/global/model/pivot_model/pivot_model.dart';

part 'role_model.g.dart';

@JsonSerializable()
@immutable
class RoleModel {
  const RoleModel({
    required this.id,
    required this.name,
    this.guardName,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  final int id;

  final String name;

  @JsonKey(name: "guard_name")
  final String? guardName;

  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;
  
  final PivotModel? pivot;

  Map<String, dynamic> toJson() => _$RoleModelToJson(this);

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);

      @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory RoleModel.fromString(String jsonString) {
    return RoleModel.fromJson(json.decode(jsonString));
  }
}
