import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/global/utils/json_converters/bool_converter.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';

part 'user_model.g.dart';

@JsonSerializable()
@immutable
class UserModel implements DeleteModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
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
    this.restaurantLongitude,
    this.restaurantLatitude,
    this.distance,
    this.longitude,
    this.latitude,
  });

  final int id;
  final String name;
  final String username;
  final String email;
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
  final String? restaurantLongitude;

  @JsonKey(name: 'restaurant_latitude')
  final String? restaurantLatitude;

  final String? distance;
  final String? longitude;
  final String? latitude;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory UserModel.fromString(String jsonString) {
    return UserModel.fromJson(json.decode(jsonString));
  }

  @override
  String get apiDeactivateUrl => "active_user_takeout?id=$id";

  @override
  String get apiDeleteUrl => "delete_user_takeout?id=$id";
}
