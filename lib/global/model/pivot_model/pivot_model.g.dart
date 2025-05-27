// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pivot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PivotModel _$PivotModelFromJson(Map<String, dynamic> json) => PivotModel(
      modelType: json['model_type'] as String,
      modelId: (json['model_id'] as num).toInt(),
      roleId: (json['role_id'] as num?)?.toInt(),
      permissionId: (json['permission_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PivotModelToJson(PivotModel instance) =>
    <String, dynamic>{
      'model_type': instance.modelType,
      'model_id': instance.modelId,
      'role_id': instance.roleId,
      'permission_id': instance.permissionId,
    };
