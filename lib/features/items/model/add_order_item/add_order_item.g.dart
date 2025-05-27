// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOrderItem _$AddOrderItemFromJson(Map<String, dynamic> json) => AddOrderItem(
      id: (json['id'] as num?)?.toInt(),
      status: json['status'] as String?,
      count: json['count'] as String?,
    );

Map<String, dynamic> _$AddOrderItemToJson(AddOrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'count': instance.count,
    };
