import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'change_password_model.g.dart';

@JsonSerializable()
@immutable
class ChangePasswordModel {
  const ChangePasswordModel({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  })  : _currentPassword = currentPassword,
        _newPassword = newPassword,
        _confirmPassword = confirmPassword;

  final String? _currentPassword;

  final String? _newPassword;

  final String? _confirmPassword;

  @JsonKey(name: "old_password")
  String get currentPassword {
    if (_currentPassword == null || _currentPassword.isEmpty) {
      throw 'Current Password is required';
    }
    return _currentPassword;
  }

  @JsonKey(name: "new_password")
  String get newPassword {
    if (_newPassword == null || _newPassword.isEmpty) {
      throw 'New Password is required';
    }
    return _newPassword;
  }

  @JsonKey(name: "confirm_password")
  String get confirmPassword {
    if (_confirmPassword == null || _confirmPassword.isEmpty) {
      throw 'Confirm Password is required';
    }
    return _confirmPassword;
  }

  ChangePasswordModel copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
  }) {
    return ChangePasswordModel(
      currentPassword: currentPassword ?? _currentPassword,
      newPassword: newPassword ?? _newPassword,
      confirmPassword: confirmPassword ?? _confirmPassword,
    );
  }

  String? verifyPassword() {
    if (_currentPassword == null ||
        _newPassword == null ||
        _confirmPassword == null) {
      return "All Fields are required";
    }
    if (_currentPassword.length < 8 ||
        _newPassword.length < 8 ||
        _confirmPassword.length < 8) {
      return "Password can't be less than 8 characters";
    }
    if (_currentPassword == _newPassword) {
      return "Current and new passwords must be different";
    }
    if (_newPassword != _confirmPassword) {
      return "New password and confirm are not equal";
    }
    return null;
  }

  Map<String, dynamic> toJson() => _$ChangePasswordModelToJson(this);

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordModelFromJson(json);
}
