import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:user_admin/features/admins/model/permission_model/permission_model.dart';
import 'package:user_admin/global/utils/json_converters/bool_converter.dart';
import 'package:user_admin/global/utils/json_converters/nullable_string_converter.dart'; // تأكد من وجود هذا
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

part 'admin_model.g.dart';

@JsonSerializable()
@immutable
class AdminModel implements DeleteModel, DropDownItemModel {
  const AdminModel({
    required this.id,
    required this.userName,
    this.email,
    required this.name,
    required this.mobile,
    this.number,
    required this.typeId,
    this.type,
    required this.isActive,
    this.avg,
    required this.restaurantId,
    this.fcmToken,
    this.roles,
    this.permissions,
  });

  @override
  final int id;

  @JsonKey(name: 'user_name')
  final String userName;

  final String? email;

  final String name;
  final String mobile;
  final int? number;

  @JsonKey(name: 'type_id')
  final int typeId;

  @NullableStringConverter()
  final String? type;

  @override
  @BoolConverter()
  @JsonKey(name: 'is_active')
  final bool isActive;

  @NullableStringConverter()
  final String? avg;

  @JsonKey(name: 'restaurant_id')
  final int restaurantId;

  @NullableStringConverter()
  @JsonKey(name: 'fcm_token')
  final String? fcmToken;

  @NullableStringConverter()
  final String? roles;

  final List<PermissionModel>? permissions;

  factory AdminModel.fromJson(Map<String, dynamic> json) =>
      _$AdminModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdminModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory AdminModel.fromString(String jsonString) {
    return AdminModel.fromJson(json.decode(jsonString));
  }

  @override
  String get apiDeactivateUrl => "active_user?id=$id";

  @override
  String get apiDeleteUrl => "delete_user?id=$id";

  @override
  String get displayName => name;
}
