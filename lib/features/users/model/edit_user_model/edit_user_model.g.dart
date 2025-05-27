// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditUserModel _$EditUserModelFromJson(Map<String, dynamic> json) =>
    EditUserModel(
      id: (json['id'] as num?)?.toInt(),
      restaurantId: (json['restaurant_id'] as num?)?.toInt(),
      name: json['name'] as String?,
      username: json['username'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$EditUserModelToJson(EditUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurant_id': instance.restaurantId,
      'name': instance.name,
      'username': instance.username,
      'phone': instance.phone,
    };
