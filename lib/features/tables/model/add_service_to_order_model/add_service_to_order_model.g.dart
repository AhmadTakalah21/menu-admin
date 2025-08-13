// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_service_to_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddServiceToOrderModel _$AddServiceToOrderModelFromJson(
        Map<String, dynamic> json) =>
    AddServiceToOrderModel(
      invoiceId: (json['invoice_id'] as num?)?.toInt(),
      tableId: (json['table_id'] as num?)?.toInt(),
      count: json['count'] as String?,
      serviceId: (json['service_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AddServiceToOrderModelToJson(
        AddServiceToOrderModel instance) =>
    <String, dynamic>{
      'invoice_id': instance.invoiceId,
      'table_id': instance.tableId,
      'count': instance.count,
      'service_id': instance.serviceId,
    };
