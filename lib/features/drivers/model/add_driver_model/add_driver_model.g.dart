// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_driver_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddDriverModel _$AddDriverModelFromJson(Map<String, dynamic> json) =>
    AddDriverModel(
      id: (json['id'] as num?)?.toInt(),
      restaurantId: (json['restaurant_id'] as num?)?.toInt(),
      birthday: json['birthday'] as String?,
      password: json['password'] as String?,
      name: json['name'] as String?,
      username: json['username'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$AddDriverModelToJson(AddDriverModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'restaurant_id': instance.restaurantId,
      'birthday': instance.birthday,
      'name': instance.name,
      'username': instance.username,
      'phone': instance.phone,
      'password': instance.password,
    };
