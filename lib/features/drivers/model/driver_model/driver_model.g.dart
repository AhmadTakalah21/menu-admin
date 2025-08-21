// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverModel _$DriverModelFromJson(Map<String, dynamic> json) => DriverModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      role: (json['role'] as num).toInt(),
      phone: json['phone'] as String,
      gender: json['gender'] as String?,
      birthday: json['birthday'] as String?,
      address: json['address'] as String?,
      restaurantId: (json['restaurant_id'] as num).toInt(),
      status: json['status'] as String?,
      isActive: const BoolConverter().fromJson(json['is_active']),
      token: json['token'] as String?,
      image: json['image'] as String,
      restaurantLongitude: json['restaurant_longitude'] as String?,
      restaurantLatitude: json['restaurant_latitude'] as String?,
      distance: DriverModel._toDouble(json['distance']),
      longitude: const NullableStringConverter().fromJson(json['longitude']),
      latitude: const NullableStringConverter().fromJson(json['latitude']),
      deliveryLongitude: json['delivery_longitude'] as String?,
      deliveryLatitude: json['delivery_latitude'] as String?,
      invoice: (json['invoice'] as List<dynamic>?)
              ?.map(
                  (e) => DriverInvoiceLite.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$DriverModelToJson(DriverModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'email': instance.email,
      'role': instance.role,
      'phone': instance.phone,
      'gender': instance.gender,
      'birthday': instance.birthday,
      'address': instance.address,
      'restaurant_id': instance.restaurantId,
      'status': instance.status,
      'is_active': const BoolConverter().toJson(instance.isActive),
      'token': instance.token,
      'image': instance.image,
      'restaurant_longitude': instance.restaurantLongitude,
      'restaurant_latitude': instance.restaurantLatitude,
      'distance': DriverModel._doubleToJson(instance.distance),
      'longitude': const NullableStringConverter().toJson(instance.longitude),
      'latitude': const NullableStringConverter().toJson(instance.latitude),
      'delivery_latitude': instance.deliveryLatitude,
      'delivery_longitude': instance.deliveryLongitude,
      'invoice': instance.invoice,
    };

DriverInvoiceLite _$DriverInvoiceLiteFromJson(Map<String, dynamic> json) =>
    DriverInvoiceLite(
      id: (json['id'] as num).toInt(),
      num: (json['num'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      customerReceivedAt: json['customer_received_at'] as String?,
      receivedAt: json['received_at'] as String?,
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
      totalEstimatedDuration:
          (json['total_estimated_duration'] as num?)?.toInt(),
      total: json['total'] as String?,
      totalWithDeliveryPrice: json['total_with_delivery_price'] as String?,
      discount: json['discount'] as String?,
      tableId: (json['table_id'] as num?)?.toInt(),
      restaurantId: (json['restaurant_id'] as num?)?.toInt(),
      url: json['url'] as String?,
      region: json['region'] as String?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
      deliveryPrice: (json['delivery_price'] as num?)?.toDouble(),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DriverInvoiceLiteToJson(DriverInvoiceLite instance) =>
    <String, dynamic>{
      'id': instance.id,
      'num': instance.num,
      'createdAt': instance.createdAt,
      'customer_received_at': instance.customerReceivedAt,
      'received_at': instance.receivedAt,
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
      'total_estimated_duration': instance.totalEstimatedDuration,
      'total': instance.total,
      'total_with_delivery_price': instance.totalWithDeliveryPrice,
      'discount': instance.discount,
      'table_id': instance.tableId,
      'restaurant_id': instance.restaurantId,
      'url': instance.url,
      'region': instance.region,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'delivery_price': instance.deliveryPrice,
      'distance_km': instance.distanceKm,
    };
