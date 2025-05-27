// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddServiceModel _$AddServiceModelFromJson(Map<String, dynamic> json) =>
    AddServiceModel(
      id: (json['id'] as num?)?.toInt(),
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
      price: json['price'] as String?,
    );

Map<String, dynamic> _$AddServiceModelToJson(AddServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_en': instance.nameEn,
      'name_ar': instance.nameAr,
      'price': instance.price,
    };
