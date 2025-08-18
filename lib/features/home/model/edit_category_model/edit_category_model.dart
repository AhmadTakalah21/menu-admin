import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'edit_category_model.g.dart';

@JsonSerializable()
@immutable
class EditCategoryModel {
  const EditCategoryModel({
    this.id,
    this.nameAr,
    this.nameEn,
    this.categoryId,
    this.image,
  });

  final int? id;

  @JsonKey(name: "name_ar")
  final String? nameAr;

  @JsonKey(name: "name_en")
  final String? nameEn;

  @JsonKey(name: "category_id")
  final int? categoryId;

  /// 🔵 رابط الصورة الأصلية من السيرفر (غير مستخدم في API، فقط للعرض المؤقت)
  final String? image;

  EditCategoryModel copyWith({
    int? id,
    String? nameAr,
    String? nameEn,
    int? categoryId,
    String? image,
  }) {
    return EditCategoryModel(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      categoryId: categoryId ?? this.categoryId,
      image: image ?? this.image,
    );
  }

  factory EditCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$EditCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$EditCategoryModelToJson(this);

  @override
  String toString() => jsonEncode(toJson());

  factory EditCategoryModel.fromString(String jsonString) =>
      EditCategoryModel.fromJson(json.decode(jsonString));
}
