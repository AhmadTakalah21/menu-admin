// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailsModel _$OrderDetailsModelFromJson(Map<String, dynamic> json) =>
    OrderDetailsModel(
      id: (json['id'] as num?)?.toInt(),
      itemId: (json['item_id'] as num?)?.toInt(),
      name: json['name'] as String,
      type: json['type'] as String?,
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
      typeEn: json['type_en'] as String?,
      typeAr: json['type_ar'] as String?,
      price: (json['price'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      total: (json['total'] as num?)?.toInt(),
      tableId: (json['table_id'] as num?)?.toInt(),
      customerId: (json['customer_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      tableNumber: (json['number_table'] as num?)?.toInt(),
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      invoiceId: (json['invoice_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderDetailsModelToJson(OrderDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_id': instance.itemId,
      'name': instance.name,
      'type': instance.type,
      'name_en': instance.nameEn,
      'name_ar': instance.nameAr,
      'type_en': instance.typeEn,
      'type_ar': instance.typeAr,
      'price': instance.price,
      'count': instance.count,
      'total': instance.total,
      'table_id': instance.tableId,
      'customer_id': instance.customerId,
      'user_id': instance.userId,
      'number_table': instance.tableNumber,
      'status': instance.status,
      'created_at': instance.createdAt,
      'invoice_id': instance.invoiceId,
    };
