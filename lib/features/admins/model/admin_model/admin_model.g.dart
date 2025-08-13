// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminModel _$AdminModelFromJson(Map<String, dynamic> json) => AdminModel(
      id: (json['id'] as num).toInt(),
      userName: json['user_name'] as String,
      email: json['email'] as String?,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      number: (json['number'] as num?)?.toInt(),
      typeId: (json['type_id'] as num).toInt(),
      type: const NullableStringConverter().fromJson(json['type']),
      isActive: const BoolConverter().fromJson(json['is_active']),
      avg: const NullableStringConverter().fromJson(json['avg']),
      restaurantId: (json['restaurant_id'] as num).toInt(),
      fcmToken: const NullableStringConverter().fromJson(json['fcm_token']),
      roles: const NullableStringConverter().fromJson(json['roles']),
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => PermissionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AdminModelToJson(AdminModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'email': instance.email,
      'name': instance.name,
      'mobile': instance.mobile,
      'number': instance.number,
      'type_id': instance.typeId,
      'type': const NullableStringConverter().toJson(instance.type),
      'is_active': const BoolConverter().toJson(instance.isActive),
      'avg': const NullableStringConverter().toJson(instance.avg),
      'restaurant_id': instance.restaurantId,
      'fcm_token': const NullableStringConverter().toJson(instance.fcmToken),
      'roles': const NullableStringConverter().toJson(instance.roles),
      'permissions': instance.permissions,
    };
