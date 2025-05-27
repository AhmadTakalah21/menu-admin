import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'sign_in_post_model.g.dart';

@JsonSerializable()
@immutable
class SignInPostModel {
  const SignInPostModel({
    String? username,
    String? password,
    this.fcmToken,
  })  : _username = username,
        _password = password;

  final String? _username;

  @JsonKey(name: 'password')
  final String? _password;

  @JsonKey(name: 'fcm_token')
  final String? fcmToken;

  SignInPostModel copyWith({
    String? username,
    String? password,
    String? fcmToken,
    String? restaurantId,
  }) {
    return SignInPostModel(
      username: username ?? _username,
      password: password ?? _password,
      fcmToken : fcmToken ?? this.fcmToken,
    );
  }

  @JsonKey(name: 'user_name')
  String get username {
    return _username ?? (throw 'Username is required');
  }

  String get password {
    return _password ?? (throw 'Password is required');
  }

  String? validateUserName() {
    if (_username == null || _username.isEmpty) {
      return "Username is required";
    }
    return null;
  }

  String? validatePassword() {
    if (_password == null || _password.isEmpty) {
      return "Password is required";
    } else if (_password.length < 8) {
      return "Password can't be less than 8 characters";
    }
    return null;
  }

  Map<String, dynamic> toJson() => _$SignInPostModelToJson(this);

  factory SignInPostModel.fromJson(Map<String, dynamic> json) =>
      _$SignInPostModelFromJson(json);
}
