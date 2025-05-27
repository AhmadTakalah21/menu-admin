// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateModel _$RateModelFromJson(Map<String, dynamic> json) => RateModel(
      id: (json['id'] as num).toInt(),
      restaurantId: (json['restaurant_id'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      birthday: (json['birthday'] as num).toInt(),
      gender: json['gender'] as String,
      restaurant: json['restaurant'] as String,
      rate: (json['rate'] as num).toInt(),
      note: json['note'] as String,
    );

Map<String, dynamic> _$RateModelToJson(RateModel instance) => <String, dynamic>{
      'id': instance.id,
      'restaurant_id': instance.restaurantId,
      'name': instance.name,
      'phone': instance.phone,
      'birthday': instance.birthday,
      'gender': instance.gender,
      'restaurant': instance.restaurant,
      'rate': instance.rate,
      'note': instance.note,
    };
