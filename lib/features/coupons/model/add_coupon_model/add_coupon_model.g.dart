// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_coupon_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddCouponModel _$AddCouponModelFromJson(Map<String, dynamic> json) =>
    AddCouponModel(
      id: (json['id'] as num?)?.toInt(),
      code: json['code'] as String?,
      fromDate: json['from_date'] as String?,
      toDate: json['to_date'] as String?,
      percent: json['percent'] as String?,
    );

Map<String, dynamic> _$AddCouponModelToJson(AddCouponModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'from_date': instance.fromDate,
      'to_date': instance.toDate,
      'percent': instance.percent,
    };
