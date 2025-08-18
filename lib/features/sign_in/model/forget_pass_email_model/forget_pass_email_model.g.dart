// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forget_pass_email_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgetPassEmailModel _$ForgetPassEmailModelFromJson(
        Map<String, dynamic> json) =>
    ForgetPassEmailModel(
      method: (json['method'] as num?)?.toInt() ?? 1,
      restaurantId:
          json['restaurant_id'] as String? ?? AppConstants.restaurantId,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$ForgetPassEmailModelToJson(
        ForgetPassEmailModel instance) =>
    <String, dynamic>{
      'method': instance.method,
      'restaurant_id': instance.restaurantId,
      'email': instance.email,
    };
