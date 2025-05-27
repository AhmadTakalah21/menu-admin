// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRequestModel _$OrderRequestModelFromJson(Map<String, dynamic> json) =>
    OrderRequestModel(
      id: (json['id'] as num).toInt(),
      responseTime: json['response_time'] as String,
      tableId: (json['table_id'] as num).toInt(),
      numberTable: (json['number_table'] as num).toInt(),
      employeeId: (json['employee_id'] as num).toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      adminId: (json['admin_id'] as num).toInt(),
    );

Map<String, dynamic> _$OrderRequestModelToJson(OrderRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'response_time': instance.responseTime,
      'table_id': instance.tableId,
      'number_table': instance.numberTable,
      'employee_id': instance.employeeId,
      'name': instance.name,
      'type': instance.type,
      'admin_id': instance.adminId,
    };
