// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTypeModel _$UserTypeModelFromJson(Map<String, dynamic> json) =>
    UserTypeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$UserTypeModelToJson(UserTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
