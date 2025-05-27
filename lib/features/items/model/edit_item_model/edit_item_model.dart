import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../add_nutrition_item_model/add_nutrition_item_model.dart';
import '../item_model/item_model.dart'; // ← لكي تستخدم NutritionModel للتحويل منه

part 'edit_item_model.g.dart';

@JsonSerializable()
@immutable
class EditItemModel {
  const EditItemModel({
    String? nameAr,
    String? nameEn,
    String? price,
    int? categoryId,
    this.id,
    this.descriptionEn,
    this.descriptionAr,
    this.isPanorama = 0,
    this.nutrition,
  })  : _categoryId = categoryId,
        _nameAr = nameAr,
        _nameEn = nameEn,
        _price = price;

  final int? id;
  final String? _nameAr;
  final String? _nameEn;
  @JsonKey(name: "description_ar")
  final String? descriptionAr;
  @JsonKey(name: "description_en")
  final String? descriptionEn;
  final String? _price;
  @JsonKey(name: "is_panorama")
  final int? isPanorama;
  final int? _categoryId;

  @JsonKey(name: "nutrition")
  final AddNutritionItemModel? nutrition;

  // Getters for safe values
  double get safeAmount => nutrition?.amount ?? 0.0;
  String get safeUnit => nutrition?.unit ?? 'g';
  double get safeKcal => nutrition?.kcal ?? 0.0;
  double get safeProtein => nutrition?.protein ?? 0.0;
  double get safeFat => nutrition?.fat ?? 0.0;
  double get safeCarbs => nutrition?.carbs ?? 0.0;

  @JsonKey(name: "name_ar")
  String get nameAr {
    if (_nameAr == null || _nameAr!.isEmpty) {
      throw "name_ar_empty".tr();
    }
    return _nameAr!;
  }

  @JsonKey(name: "name_en")
  String get nameEn {
    if (_nameEn == null || _nameEn!.isEmpty) {
      throw "name_en_empty".tr();
    }
    return _nameEn!;
  }

  String get price {
    if (_price == null || _price!.isEmpty) {
      throw "price_empty".tr();
    }
    return _price!;
  }

  @JsonKey(name: "category_id")
  int get categoryId {
    return _categoryId ?? (throw "category_id_empty".tr());
  }

  factory EditItemModel.fromJson(Map<String, dynamic> json) {
    if (json['nutrition'] == null) {
      json['nutrition'] = {
        'amount': 0,
        'unit': 'g',
        'kcal': 0,
        'protein': 0,
        'fat': 0,
        'carbs': 0,
      };
    }
    return _$EditItemModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EditItemModelToJson(this);

  @override
  String toString() => jsonEncode(toJson());

  factory EditItemModel.fromString(String jsonString) =>
      EditItemModel.fromJson(json.decode(jsonString));

  EditItemModel copyWith({
    int? id,
    String? nameAr,
    String? nameEn,
    String? descriptionAr,
    String? descriptionEn,
    String? price,
    int? isPanorama,
    int? categoryId,
    AddNutritionItemModel? nutrition,
  }) {
    return EditItemModel(
      id: id ?? this.id,
      nameAr: nameAr ?? _nameAr,
      nameEn: nameEn ?? _nameEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      price: price ?? _price,
      isPanorama: isPanorama ?? this.isPanorama,
      categoryId: categoryId ?? _categoryId,
      nutrition: nutrition ?? this.nutrition,
    );
  }

  /// ✅ دالة لتحديث جزء من بيانات التغذية فقط
  EditItemModel copyWithNutrition({
    double? amount,
    String? unit,
    double? kcal,
    double? protein,
    double? fat,
    double? carbs,
  }) {
    return copyWith(
      nutrition: (nutrition ?? AddNutritionItemModel.empty()).copyWith(
        amount: amount,
        unit: unit,
        kcal: kcal,
        protein: protein,
        fat: fat,
        carbs: carbs,
      ),
    );
  }

  /// ✅ دالة لتحويل NutritionModel إلى AddNutritionItemModel
  static AddNutritionItemModel fromNutritionModel(NutritionModel model) {
    return AddNutritionItemModel(
      id: model.id,
      amount: model.amount,
      unit: model.unit,
      kcal: model.kcal,
      protein: model.protein,
      fat: model.fat,
      carbs: model.carbs,
    );
  }
}
