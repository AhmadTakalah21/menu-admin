// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_size_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddSizeItemModel _$AddSizeItemModelFromJson(Map<String, dynamic> json) =>
    AddSizeItemModel(
      id: (json['id'] as num?)?.toInt(),
      price: json['price'] as String?,
      name: json['name'] as String?,
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
    );

Map<String, dynamic> _$AddSizeItemModelToJson(AddSizeItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'name': instance.name,
      'name_en': instance.nameEn,
      'name_ar': instance.nameAr,
    };
