// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drvier_invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DrvierInvoiceModel _$DrvierInvoiceModelFromJson(Map<String, dynamic> json) =>
    DrvierInvoiceModel(
      id: (json['id'] as num).toInt(),
      number: (json['num'] as num).toInt(),
      createdAt: json['created_at'] as String,
      customerReceivedAt: json['customer_received_at'] as String?,
      receivedAt: json['received_at'] as String?,
      adminId: (json['admin_id'] as num?)?.toInt(),
      adminName: json['admin_name'] as String?,
      customerId: (json['customer_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      user: json['user'] as String?,
      username: json['username'] as String?,
      userPhone: json['user_phone'] as String?,
      deliveryName: json['delivery_name'] as String?,
      deliveryPhone: json['delivery_phone'] as String?,
      deliveryAddress: json['delivery_address'] as String?,
      price: json['price'] as String?,
      status: json['status'] as String?,
      total: json['total'] as String?,
      totalWithDeliveryPrice: json['total_with_delivery_price'] as String?,
      discount: json['discount'] as String?,
      tableId: (json['table_id'] as num?)?.toInt(),
      tableNumber: (json['number_table'] as num?)?.toInt(),
      restaurantId: (json['restaurant_id'] as num).toInt(),
      restaurantName: json['restaurant_name'] as String?,
      logo: json['logo'] as String?,
      waiter: json['waiter'] as String?,
      url: json['url'] as String?,
      region: json['region'] as String?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
      deliveryPrice:
          const NullableStringConverter().fromJson(json['delivery_price']),
      orders: (json['orders'] as List<dynamic>)
          .map((e) => OrderDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      consumerSpending: json['consumer_spending'] as String?,
      localAdministration: json['local_administration'] as String?,
      reconstruction: json['reconstruction'] as String?,
    );

Map<String, dynamic> _$DrvierInvoiceModelToJson(DrvierInvoiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'num': instance.number,
      'created_at': instance.createdAt,
      'customer_received_at': instance.customerReceivedAt,
      'received_at': instance.receivedAt,
      'admin_id': instance.adminId,
      'admin_name': instance.adminName,
      'customer_id': instance.customerId,
      'user_id': instance.userId,
      'user': instance.user,
      'username': instance.username,
      'user_phone': instance.userPhone,
      'delivery_name': instance.deliveryName,
      'delivery_phone': instance.deliveryPhone,
      'delivery_address': instance.deliveryAddress,
      'price': instance.price,
      'status': instance.status,
      'total': instance.total,
      'total_with_delivery_price': instance.totalWithDeliveryPrice,
      'discount': instance.discount,
      'table_id': instance.tableId,
      'number_table': instance.tableNumber,
      'restaurant_id': instance.restaurantId,
      'restaurant_name': instance.restaurantName,
      'logo': instance.logo,
      'waiter': instance.waiter,
      'url': instance.url,
      'region': instance.region,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'delivery_price':
          const NullableStringConverter().toJson(instance.deliveryPrice),
      'orders': instance.orders,
      'consumer_spending': instance.consumerSpending,
      'local_administration': instance.localAdministration,
      'reconstruction': instance.reconstruction,
    };
