import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_profile_model.g.dart';

@JsonSerializable()
@immutable
class UpdateProfileModel {
  const UpdateProfileModel({
    String? name,
    String? username,
    String? password,
  })  : _name = name,
        _username = username,
        _password = password;

  final String? _name;

  @JsonKey(name: "user_name")
  final String? _username;

  final String? _password;

  String get password {
    if (_password == null || _password.isEmpty) {
      throw "password_empty".tr();
    }
    return _password;
  }

  String get username {
    if (_username == null || _username.isEmpty) {
      throw "username_empty".tr();
    }
    return _username;
  }

  String get name {
    if (_name == null || _name.isEmpty) {
      throw "name_empty".tr();
    }
    return _name;
  }

  factory UpdateProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory UpdateProfileModel.fromString(String jsonString) {
    return UpdateProfileModel.fromJson(json.decode(jsonString));
  }

  UpdateProfileModel copyWith({
    String? name,
    String? username,
    String? password,
  }) {
    return UpdateProfileModel(
      name: name ?? _name,
      username: username ?? _username,
      password: password ?? _password,
    );
  }
}
