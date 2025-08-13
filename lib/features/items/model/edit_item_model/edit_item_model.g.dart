// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditItemModel _$EditItemModelFromJson(Map<String, dynamic> json) =>
    EditItemModel(
      nameAr: json['name_ar'] as String?,
      nameEn: json['name_en'] as String?,
      price: json['price'] as String?,
      categoryId: (json['category_id'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
      descriptionEn: json['description_en'] as String?,
      descriptionAr: json['description_ar'] as String?,
      isPanorama: (json['is_panorama'] as num?)?.toInt() ?? 0,
      nutrition: json['nutrition'] == null
          ? null
          : AddNutritionItemModel.fromJson(
              json['nutrition'] as Map<String, dynamic>),
      image: json['image'] as String?,
      icon: json['icon'] as String?,
    );

Map<String, dynamic> _$EditItemModelToJson(EditItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description_ar': instance.descriptionAr,
      'description_en': instance.descriptionEn,
      'is_panorama': instance.isPanorama,
      'nutrition': instance.nutrition,
      'image': instance.image,
      'icon': instance.icon,
      'name_ar': instance.nameAr,
      'name_en': instance.nameEn,
      'price': instance.price,
      'category_id': instance.categoryId,
    };
