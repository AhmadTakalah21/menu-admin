// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditCategoryModel _$EditCategoryModelFromJson(Map<String, dynamic> json) =>
    EditCategoryModel(
      id: (json['id'] as num?)?.toInt(),
      nameAr: json['name_ar'] as String?,
      nameEn: json['name_en'] as String?,
      categoryId: (json['category_id'] as num?)?.toInt(),
      image: json['image'] as String?,
    );

Map<String, dynamic> _$EditCategoryModelToJson(EditCategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_ar': instance.nameAr,
      'name_en': instance.nameEn,
      'category_id': instance.categoryId,
      'image': instance.image,
    };
