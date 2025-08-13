import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';

part 'sign_in_model.g.dart';

@JsonSerializable()
@immutable
class SignInModel {
  const SignInModel({
    required this.id,
    required this.userName,
    required this.name,
    required this.token,
    required this.type,
    required this.typeId,
    required this.restaurantId,
    required this.restaurant,
    required this.roles,
    required this.permissions,
  });

  final int id;

  @JsonKey(name: "user_name")
  final String userName;

  final String name;

  final String token;

  final String? type;

  @JsonKey(name: "type_id")
  final int typeId;

  @JsonKey(name: "restaurant_id")
  final int restaurantId;

  final RestaurantModel restaurant;

  final List<RoleModel> roles;

  final List<RoleModel> permissions;

  Map<String, dynamic> toJson() => _$SignInModelToJson(this);

  factory SignInModel.fromJson(Map<String, dynamic> json) =>
      _$SignInModelFromJson(json);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory SignInModel.fromString(String jsonString) {
    return SignInModel.fromJson(json.decode(jsonString));
  }
}
