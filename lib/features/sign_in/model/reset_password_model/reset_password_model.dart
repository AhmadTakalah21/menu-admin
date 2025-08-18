import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'reset_password_model.g.dart';

@JsonSerializable()
@immutable
class ResetPasswordModel {
  const ResetPasswordModel({
    String? password,
    String? repeatPassword,
  })  : _password = password,
        _repeatPassword = repeatPassword;

  final String? _password;

  final String? _repeatPassword;

  String get password {
    if (_password == null || _password.isEmpty) {
      throw 'Password is required';
    }
    return _password;
  }

  String? verifyPassword() {
    if (_password == null ||
        _repeatPassword == null ||
        _password.isEmpty ||
        _repeatPassword.isEmpty) {
      return "Password can't be empty";
    }
    if (_password.length < 8 || _repeatPassword.length < 8) {
      return "Password can't be less than 8 characters";
    }
    if (_password != _repeatPassword) {
      return "Passwords are not equal";
    }
    return null;
  }

  @JsonKey(name: "repeat_password")
  String get repeatPassword {
    if (_repeatPassword == null || _repeatPassword.isEmpty) {
      throw 'Repeat password is required';
    }
    return _repeatPassword;
  }

  ResetPasswordModel copyWith({
    String? password,
    String? repeatPassword,
  }) {
    return ResetPasswordModel(
      password: password ?? _password,
      repeatPassword: repeatPassword ?? _repeatPassword,
    );
  }

  Map<String, dynamic> toJson() => _$ResetPasswordModelToJson(this);

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordModelFromJson(json);
}
