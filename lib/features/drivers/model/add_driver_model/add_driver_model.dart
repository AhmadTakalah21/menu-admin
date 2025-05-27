import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_driver_model.g.dart';

@JsonSerializable()
@immutable
class AddDriverModel {
  const AddDriverModel({
    this.id,
    this.restaurantId,
    this.birthday,
    String? password,
    String? name,
    String? username,
    String? phone,
  })  : _name = name,
        _username = username,
        _password = password,
        _phone = phone;

  final int? id;

  @JsonKey(name: "restaurant_id")
  final int? restaurantId;

  final String? _name;
  final String? _username;
  final String? _password;
  final String? _phone;
  final String? birthday;

  String get name {
    if (_name == null || _name.isEmpty) throw "name_empty".tr();
    return _name;
  }

  String get username {
    if (_username == null || _username.isEmpty) throw "username_empty".tr();
    return _username;
  }

  String get phone {
    if (_phone == null || _phone.isEmpty) throw "phone_empty".tr();
    return _phone;
  }

  String get password {
    if (_password == null || _password.isEmpty) throw "password_empty".tr();
    return _password;
  }

  AddDriverModel copyWith({
    int? id,
    int? restaurantId,
    String? name,
    String? username,
    String? password,
    String? phone,
    String? birthday,
  }) {
    return AddDriverModel(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? _name,
      username: username ?? _username,
      password: password ?? _password,
      phone: phone ?? _phone,
      birthday: birthday ?? this.birthday,
    );
  }

  factory AddDriverModel.fromJson(Map<String, dynamic> json) =>
      _$AddDriverModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddDriverModelToJson(this);

  @override
  String toString() => jsonEncode(toJson());

  factory AddDriverModel.fromString(String jsonString) =>
      AddDriverModel.fromJson(json.decode(jsonString));
}
