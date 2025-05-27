// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignInModel _$SignInModelFromJson(Map<String, dynamic> json) => SignInModel(
      id: (json['id'] as num).toInt(),
      userName: json['user_name'] as String,
      name: json['name'] as String,
      token: json['token'] as String,
      type: json['type'] as String,
      typeId: (json['type_id'] as num).toInt(),
      restaurantId: (json['restaurant_id'] as num).toInt(),
      restaurant:
          RestaurantModel.fromJson(json['restaurant'] as Map<String, dynamic>),
      roles: (json['roles'] as List<dynamic>)
          .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      permissions: (json['permissions'] as List<dynamic>)
          .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SignInModelToJson(SignInModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'name': instance.name,
      'token': instance.token,
      'type': instance.type,
      'type_id': instance.typeId,
      'restaurant_id': instance.restaurantId,
      'restaurant': instance.restaurant,
      'roles': instance.roles,
      'permissions': instance.permissions,
    };
