// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponModel _$CouponModelFromJson(Map<String, dynamic> json) => CouponModel(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      fromDate: json['from_date'] as String,
      toDate: json['to_date'] as String,
      type: json['type'] as String,
      percent: (json['percent'] as num).toInt(),
      isActive: const BoolConverter().fromJson(json['is_active']),
      restaurantId: (json['restaurant_id'] as num).toInt(),
    );

Map<String, dynamic> _$CouponModelToJson(CouponModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'from_date': instance.fromDate,
      'to_date': instance.toDate,
      'type': instance.type,
      'percent': instance.percent,
      'is_active': const BoolConverter().toJson(instance.isActive),
      'restaurant_id': instance.restaurantId,
    };
