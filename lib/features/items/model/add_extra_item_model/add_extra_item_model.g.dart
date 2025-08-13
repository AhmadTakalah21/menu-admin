// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_extra_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddExtraItemModel _$AddExtraItemModelFromJson(Map<String, dynamic> json) =>
    AddExtraItemModel(
      id: (json['id'] as num?)?.toInt(),
      price: json['price'] as String?,
      icon: json['icon'] as String?,
      name: json['name'] as String?,
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
      itemId: (json['itemId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AddExtraItemModelToJson(AddExtraItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'icon': instance.icon,
      'name': instance.name,
      'name_en': instance.nameEn,
      'name_ar': instance.nameAr,
      'itemId': instance.itemId,
    };
