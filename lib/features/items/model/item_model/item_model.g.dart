// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      index: (json['index'] as num).toInt(),
      isActive: const BoolConverter().fromJson(json['is_active']),
      image: json['image'] as String,
      icon: json['icon'] as String?,
      restaurantId: (json['restaurant_id'] as num).toInt(),
      restaurant: json['restaurant'] as String,
      category: json['category'] as String,
      categoryId: const IntConverter().fromJson(json['category_id']),
      isPanorama: const IntConverter().fromJson(json['is_panorama']),
      itemTypes: (json['toppings'] as List<dynamic>?)
          ?.map((e) => ItemTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sizesTypes: (json['sizes'] as List<dynamic>?)
          ?.map((e) => ItemTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      componentsTypes: (json['components'] as List<dynamic>?)
          ?.map((e) => ItemTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isBasicComponent: json['is_basic_component'] == null
          ? 0
          : const IntConverter().fromJson(json['is_basic_component']),
      price: const StringConverter().fromJson(json['price']),
      description: json['description'] as String?,
      descriptionEn: json['description_en'] as String?,
      descriptionAr: json['description_ar'] as String?,
      nutrition: ItemModel._nutritionFromJson(json['nutrition']),
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'name_en': instance.nameEn,
      'price': const StringConverter().toJson(instance.price),
      'description': instance.description,
      'description_en': instance.descriptionEn,
      'description_ar': instance.descriptionAr,
      'index': instance.index,
      'is_active': const BoolConverter().toJson(instance.isActive),
      'image': instance.image,
      'icon': instance.icon,
      'restaurant_id': instance.restaurantId,
      'restaurant': instance.restaurant,
      'category': instance.category,
      'category_id': const IntConverter().toJson(instance.categoryId),
      'is_panorama': const IntConverter().toJson(instance.isPanorama),
      'toppings': instance.itemTypes.map((e) => e.toJson()).toList(),
      'sizes': instance.sizesTypes.map((e) => e.toJson()).toList(),
      'components': instance.componentsTypes.map((e) => e.toJson()).toList(),
      'is_basic_component':
          const IntConverter().toJson(instance.isBasicComponent),
      'nutrition': instance.nutrition?.toJson(),
    };

NutritionModel _$NutritionModelFromJson(Map<String, dynamic> json) =>
    NutritionModel(
      id: (json['id'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
      kcal: (json['kcal'] as num?)?.toDouble(),
      protein: (json['protein'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      carbs: (json['carbs'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$NutritionModelToJson(NutritionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'unit': instance.unit,
      'kcal': instance.kcal,
      'protein': instance.protein,
      'fat': instance.fat,
      'carbs': instance.carbs,
    };
