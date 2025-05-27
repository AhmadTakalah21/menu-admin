// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInPostModel _$SignInPostModelFromJson(Map<String, dynamic> json) =>
    SignInPostModel(
      username: json['user_name'] as String?,
      password: json['password'] as String?,
      fcmToken: json['fcm_token'] as String?,
    );

Map<String, dynamic> _$SignInPostModelToJson(SignInPostModel instance) =>
    <String, dynamic>{
      'fcm_token': instance.fcmToken,
      'user_name': instance.username,
      'password': instance.password,
    };
