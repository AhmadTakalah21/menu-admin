import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'edit_user_model.g.dart';

@JsonSerializable()
@immutable
class EditUserModel {
  const EditUserModel({
    this.id,
    this.restaurantId,
    this.name,
    this.username,
    this.phone,
  });

  final int? id;

  @JsonKey(name: "restaurant_id")
  final int? restaurantId;

  final String? name;
  final String? username;
  final String? phone;

  EditUserModel copyWith({
    int? id,
    int? restaurantId,
    String? name,
    String? username,
    String? password,
    String? phone,
  }) {
    return EditUserModel(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      username: username ?? this.username,
      phone: phone ?? this.phone,
    );
  }

  factory EditUserModel.fromJson(Map<String, dynamic> json) =>
      _$EditUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$EditUserModelToJson(this);

  @override
  String toString() => jsonEncode(toJson());

  factory EditUserModel.fromString(String jsonString) =>
      EditUserModel.fromJson(json.decode(jsonString));
}
