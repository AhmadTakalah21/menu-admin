// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminModel _$AdminModelFromJson(Map<String, dynamic> json) => AdminModel(
      id: (json['id'] as num).toInt(),
      userName: json['user_name'] as String,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      number: (json['number'] as num?)?.toInt(),
      typeId: (json['type_id'] as num).toInt(),
      type: json['type'] as String?,
      isActive: const BoolConverter().fromJson(json['is_active']),
      avg: json['avg'] as String?,
      restaurantId: (json['restaurant_id'] as num).toInt(),
      fcmToken: json['fcm_token'] as String?,
      roles: json['roles'] as String?,
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => PermissionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AdminModelToJson(AdminModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'name': instance.name,
      'mobile': instance.mobile,
      'number': instance.number,
      'type_id': instance.typeId,
      'type': instance.type,
      'is_active': const BoolConverter().toJson(instance.isActive),
      'avg': instance.avg,
      'restaurant_id': instance.restaurantId,
      'fcm_token': instance.fcmToken,
      'roles': instance.roles,
      'permissions': instance.permissions,
    };
