// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_admin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAdminModel _$UpdateAdminModelFromJson(Map<String, dynamic> json) =>
    UpdateAdminModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      username: json['user_name'] as String?,
      password: json['password'] as String?,
      mobile: json['mobile'] as String?,
      typeId: (json['type_id'] as num?)?.toInt(),
      role: json['role'] as String?,
      categories: (json['category'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$UpdateAdminModelToJson(UpdateAdminModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'user_name': instance.username,
      'password': instance.password,
      'mobile': instance.mobile,
      'type_id': instance.typeId,
      'role': instance.role,
      'category': instance.categories,
    };
