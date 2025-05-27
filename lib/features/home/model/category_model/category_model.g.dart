// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      image: json['image'] as String,
      isActive: const BoolConverter().fromJson(json['is_active']),
      index: (json['index'] as num).toInt(),
      categoryId: const NullableIntConverter().fromJson(json['category_id']),
      content: (json['content'] as num).toInt(),
      subCategories: (json['sub_category'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'name_en': instance.nameEn,
      'image': instance.image,
      'is_active': const BoolConverter().toJson(instance.isActive),
      'index': instance.index,
      'category_id': const NullableIntConverter().toJson(instance.categoryId),
      'content': instance.content,
      'sub_category': instance.subCategories,
      'items': instance.items,
    };
