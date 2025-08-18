import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/global/utils/constants.dart';

part 'forget_pass_email_model.g.dart';

@JsonSerializable()
@immutable
class ForgetPassEmailModel {
  const ForgetPassEmailModel({
    this.method = 1,
    this.restaurantId = AppConstants.restaurantId,
    String? email,
  }) : _email = email;

  final int method;

  final String? _email;

  @JsonKey(name: 'restaurant_id')
  final String restaurantId;

  ForgetPassEmailModel copyWith({String? email}) {
    return ForgetPassEmailModel(email: email ?? _email);
  }

  String? validateEmail() {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (_email == null || _email.isEmpty) {
      return "Email is required";
    } else if (!emailRegex.hasMatch(email)) {
      return "Invalid email";
    }
    return null;
  }

  String get email {
    if (_email == null || _email.isEmpty) {
      throw 'Email is required';
    }
    return _email;
  }

  Map<String, dynamic> toJson() => _$ForgetPassEmailModelToJson(this);

  factory ForgetPassEmailModel.fromJson(Map<String, dynamic> json) =>
      _$ForgetPassEmailModelFromJson(json);
}
