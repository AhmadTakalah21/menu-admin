// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_advertisement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddAdvertisementModel _$AddAdvertisementModelFromJson(
        Map<String, dynamic> json) =>
    AddAdvertisementModel(
      id: (json['id'] as num?)?.toInt(),
      isPanorama: (json['is_panorama'] as num?)?.toInt() ?? 0,
      hideDate: (json['hide_date'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,
      fromDate: json['from_date'] as String?,
      toDate: json['to_date'] as String?,
    );

Map<String, dynamic> _$AddAdvertisementModelToJson(
        AddAdvertisementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_panorama': instance.isPanorama,
      'hide_date': instance.hideDate,
      'title': instance.title,
      'from_date': instance.fromDate,
      'to_date': instance.toDate,
    };
