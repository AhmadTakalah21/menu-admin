import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_admin_model.g.dart';

@JsonSerializable()
@immutable
class UpdateAdminModel {
  const UpdateAdminModel({
    this.id,
    String? name,
    String? username,
    String? email,
    String? password,
    String? mobile,
    int? typeId,
    String? role,
    List<int> categories = const [],
  })  : _name = name,
        _username = username,
        _email = email,
      _password = password,
        _mobile = mobile,
        _typeId = typeId,
        _role = role,
        _categories = categories;

  final int? id;

  final String? _name;

  final String? _username;

  final String? _email;

  final String? _password;

  final String? _mobile;

  final int? _typeId;

  final String? _role;

  final List<int> _categories;

  String get name {
    if (_name == null || _name.isEmpty) {
      throw "name_empty".tr();
    }
    return _name;
  }

  @JsonKey(name: "user_name")
  String get username {
    if (_username == null || _username.isEmpty) {
      throw "username_empty".tr();
    }
    return _username;
  }

  String get email {
    if (_email == null || _email.isEmpty) {
      throw "email_empty".tr();
    }
    return _email;
  }

  String get password {
    if (_password == null || _password.isEmpty) {
      throw "password_empty".tr();
    } else if (_password.length < 8) {
      throw "password_short".tr();
    }
    return _password;
  }

  String get mobile {
    if (_mobile == null || _mobile.isEmpty) {
      throw "phone_empty".tr();
    }
    return _mobile;
  }

  @JsonKey(name: "type_id")
  int? get typeId {
    if (_role == "employee" || _role == "موظف") {
      return _typeId ?? (throw "type_empty".tr());
    }
    return null;
  }

  String get role {
    if (_role == null || _role.isEmpty) {
      throw "role_empty".tr();
    }
    return _role;
  }

  @JsonKey(name: "category")
  List<int>? get categories {
    if (_typeId == 4 || _typeId == 8) {
      return _categories.isEmpty ? [] : _categories;
    }
    return null;
  }


  Map<String, dynamic> toJson() => _$UpdateAdminModelToJson(this);

  factory UpdateAdminModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateAdminModelFromJson(json);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory UpdateAdminModel.fromString(String jsonString) {
    return UpdateAdminModel.fromJson(json.decode(jsonString));
  }

  UpdateAdminModel copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    String? password,
    String? mobile,
    int? typeId,
    String? role,
    List<int> categories = const [],
  }) {
    return UpdateAdminModel(
      id: id ?? this.id,
      name: name ?? _name,
      username: username ?? _username,
      email: email ?? _email,
      password: password ?? _password,
      mobile: mobile ?? _mobile,
      typeId: typeId ?? _typeId,
      role: role ?? _role,
      categories: categories,
    );
  }
}
