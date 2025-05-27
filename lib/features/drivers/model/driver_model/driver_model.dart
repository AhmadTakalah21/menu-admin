import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_admin/global/utils/json_converters/bool_converter.dart';
import 'package:user_admin/global/utils/json_converters/string_converter.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

part 'driver_model.g.dart';

@JsonSerializable()
@immutable
class DriverModel implements DeleteModel, DropDownItemModel {
  const DriverModel({
    required this.id,
    required this.name,
    required this.username,
    this.email,
    required this.role,
    required this.phone,
    this.gender,
    this.birthday,
    this.address,
    required this.restaurantId,
    this.status,
    required this.isActive,
    this.token,
    required this.image,
    required this.restaurantLongitude,
    required this.restaurantLatitude,
    this.distance,
    this.longitude,
    this.latitude,
  });

  @override
  final int id;
  final String name;
  final String username;
  final String? email;
  final int role;
  final String phone;
  final String? gender;
  final String? birthday;
  final String? address;

  @JsonKey(name: 'restaurant_id')
  final int restaurantId;

  final String? status;

  @override
  @BoolConverter()
  @JsonKey(name: 'is_active')
  final bool isActive;

  final String? token;
  final String image;

  @JsonKey(name: 'restaurant_longitude')
  final String restaurantLongitude;

  @JsonKey(name: 'restaurant_latitude')
  final String restaurantLatitude;

  @NullableStringConverter()
  final String? distance;
  @NullableStringConverter()
  final String? longitude;
  @NullableStringConverter()
  final String? latitude;

  factory DriverModel.fromJson(Map<String, dynamic> json) =>
      _$DriverModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory DriverModel.fromString(String jsonString) {
    return DriverModel.fromJson(json.decode(jsonString));
  }

  @override
  String get apiDeactivateUrl => "active_delivery?id=$id";

  @override
  String get apiDeleteUrl => "delete_delivery?$id";

  @override
  String get displayName =>
      "${"name".tr()}: $name   ${"distance".tr()}: ${distance?.substring(0, 5) ?? "unprovided".tr()}";
}
