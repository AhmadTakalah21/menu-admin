import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
@immutable
class ProfileModel {
  const ProfileModel({
    required this.name,
    required this.username,
  });

  final String name;

  @JsonKey(name: "user_name")
  final String username;
  
  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory ProfileModel.fromString(String jsonString) {
    return ProfileModel.fromJson(json.decode(jsonString));
  }
}
