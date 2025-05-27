// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advertisement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvertisementModel _$AdvertisementModelFromJson(Map<String, dynamic> json) =>
    AdvertisementModel(
      id: (json['id'] as num).toInt(),
      image: json['image'] as String,
      title: json['title'] as String,
      restaurant: json['restaurant'] as String,
      fromDate: json['from_date'] as String,
      toDate: json['to_date'] as String,
      isPanorama: (json['is_panorama'] as num).toInt(),
      hideDate: (json['hide_date'] as num).toInt(),
    );

Map<String, dynamic> _$AdvertisementModelToJson(AdvertisementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'title': instance.title,
      'restaurant': instance.restaurant,
      'from_date': instance.fromDate,
      'to_date': instance.toDate,
      'is_panorama': instance.isPanorama,
      'hide_date': instance.hideDate,
    };
