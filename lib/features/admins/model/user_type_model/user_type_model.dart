import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

part 'user_type_model.g.dart';

@JsonSerializable()
@immutable
class UserTypeModel implements DropDownItemModel {
  const UserTypeModel({
    required this.id,
    required this.name,
  });

  @override
  final int id;
  final String name;

  factory UserTypeModel.fromJson(Map<String, dynamic> json) =>
      _$UserTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserTypeModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory UserTypeModel.fromString(String jsonString) {
    return UserTypeModel.fromJson(json.decode(jsonString));
  }

  @override
  String get displayName => name;

   @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTypeModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
