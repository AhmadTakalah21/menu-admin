import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:user_admin/features/home/view/widgets/category_tile.dart';
import 'package:user_admin/features/items/model/item_type_model/item_type_model.dart';
import 'package:user_admin/global/utils/json_converters/bool_converter.dart';
import 'package:user_admin/global/utils/json_converters/int_converter.dart';
import 'package:user_admin/global/utils/json_converters/string_converter.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

part 'item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ItemModel implements DeleteModel, ItemTileModel, DropDownItemModel {
  ItemModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.nameEn,
    required this.index,
    required this.isActive,
    required this.image,
    this.icon,
    required this.restaurantId,
    required this.restaurant,
    required this.category,
    required this.categoryId,
    required this.isPanorama,
    List<ItemTypeModel>? itemTypes,
    List<ItemTypeModel>? sizesTypes,
    List<ItemTypeModel>? componentsTypes,
    this.isBasicComponent = 0,
    required this.price,
    this.description,
    this.descriptionEn,
    this.descriptionAr,
    this.nutrition,
  })  : itemTypes = itemTypes ?? [],
        sizesTypes = sizesTypes ?? [],
        componentsTypes = componentsTypes ?? [];

  @override
  final int id;

  final String name;

  @override
  @JsonKey(name: "name_ar")
  final String nameAr;

  @override
  @JsonKey(name: "name_en")
  final String nameEn;

  @StringConverter()
  final String price;

  final String? description;

  @JsonKey(name: "description_en")
  final String? descriptionEn;

  @JsonKey(name: "description_ar")
  final String? descriptionAr;

  final int index;

  @override
  @BoolConverter()
  @JsonKey(name: "is_active")
  final bool isActive;

  @override
  final String image;
  final String? icon;

  @JsonKey(name: "restaurant_id")
  final int restaurantId;

  final String restaurant;
  final String category;

  @IntConverter()
  @JsonKey(name: "category_id")
  final int categoryId;

  @IntConverter()
  @JsonKey(name: "is_panorama")
  final int isPanorama;

  @JsonKey(name: "toppings")
  final List<ItemTypeModel> itemTypes;

  @JsonKey(name: "sizes")
  final List<ItemTypeModel> sizesTypes;

  @JsonKey(name: "components")
  final List<ItemTypeModel> componentsTypes;

  @IntConverter()
  @JsonKey(name: "is_basic_component")
  final int isBasicComponent;

  @JsonKey(name: "nutrition", fromJson: _nutritionFromJson)
  final NutritionModel? nutrition;

  static NutritionModel _nutritionFromJson(dynamic json) {
    if (json == null) {
      return NutritionModel.empty();
    }
    return NutritionModel.fromJson(json as Map<String, dynamic>);
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemModelToJson(this);

  double get safeWeight => nutrition?.safeAmount ?? 0.0;
  double get safeCalories => nutrition?.safeKcal ?? 0.0;
  double get safeProtein => nutrition?.safeProtein ?? 0.0;
  double get safeFat => nutrition?.safeFat ?? 0.0;
  double get safeCarbs => nutrition?.safeCarbs ?? 0.0;
  String get safeUnit => nutrition?.safeUnit ?? 'g';

  @override
  String toString() => jsonEncode(toJson());

  factory ItemModel.fromString(String jsonString) =>
      ItemModel.fromJson(json.decode(jsonString));

  @override
  String get apiDeactivateUrl => "deactivate_item?id=$id";

  @override
  String get apiDeleteUrl => "delete_item?id=$id";

  @override
  String get displayName => name;



  ItemModel copyWith({
    NutritionModel? nutrition,
  }) {
    return ItemModel(
      id: id,
      name: name,
      nameAr: nameAr,
      nameEn: nameEn,
      index: index,
      isActive: isActive,
      image: image,
      icon: icon,
      restaurantId: restaurantId,
      restaurant: restaurant,
      category: category,
      categoryId: categoryId,
      isPanorama: isPanorama,
      itemTypes: itemTypes,
      sizesTypes: sizesTypes,
      componentsTypes: componentsTypes,
      isBasicComponent: isBasicComponent,
      price: price,
      description: description,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      nutrition: nutrition ?? this.nutrition,
    );
  }
}

@JsonSerializable()
class NutritionModel {
  final int? id;
  final double? amount;
  final String? unit;
  final double? kcal;
  final double? protein;
  final double? fat;
  final double? carbs;

  const NutritionModel({
    this.id,
    this.amount,
    this.unit,
    this.kcal,
    this.protein,
    this.fat,
    this.carbs,
  });

  factory NutritionModel.empty() => const NutritionModel(
    amount: 0,
    unit: 'g',
    kcal: 0,
    protein: 0,
    fat: 0,
    carbs: 0,
  );

  NutritionModel copyWith({
    int? id,
    double? amount,
    String? unit,
    double? kcal,
    double? protein,
    double? fat,
    double? carbs,
  }) {
    return NutritionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      kcal: kcal ?? this.kcal,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
    );
  }

  factory NutritionModel.fromJson(Map<String, dynamic> json) =>
      _$NutritionModelFromJson(json);

  Map<String, dynamic> toJson() => _$NutritionModelToJson(this);

  double get safeAmount => amount ?? 0.0;
  String get safeUnit => unit ?? 'g';
  double get safeKcal => kcal ?? 0.0;
  double get safeProtein => protein ?? 0.0;
  double get safeFat => fat ?? 0.0;
  double get safeCarbs => carbs ?? 0.0;
}
