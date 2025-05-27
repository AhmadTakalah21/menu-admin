// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemTypeModel _$ItemTypeModelFromJson(Map<String, dynamic> json) =>
    ItemTypeModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
      price: const StringConverter().fromJson(json['price']),
      image: json['image'] as String?,
      itemId: (json['item_id'] as num?)?.toInt(),
      isBasicComponent: (json['is_basic'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ItemTypeModelToJson(ItemTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'item_id': instance.itemId,
      'name': instance.name,
      'name_en': instance.nameEn,
      'name_ar': instance.nameAr,
      'price': _$JsonConverterToJson<dynamic, String>(
          instance.price, const StringConverter().toJson),
      'image': instance.image,
      'is_basic': instance.isBasicComponent,
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
