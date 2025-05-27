import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'edit_category_model.g.dart';

@JsonSerializable()
@immutable
class EditCategoryModel {
  const EditCategoryModel({
    int? id,
    String? nameAr,
    String? nameEn,
    int? categoryId,
  })  : _id = id,
        _nameAr = nameAr,
        _nameEn = nameEn,
        _categoryId = categoryId;

  final int? _id;
  final String? _nameAr;
  final String? _nameEn;
  final int? _categoryId;

  int? get id {
    return _id;
  }

  @JsonKey(name: "name_ar")
  String get nameAr {
    return _nameAr ?? (throw "name_ar_empty".tr());
  }

  @JsonKey(name: "name_en")
  String get nameEn {
    return _nameEn ?? (throw "name_ar_empty".tr());
  }

  @JsonKey(name: "category_id")
  int? get categoryId {
    return _categoryId;
  }

  EditCategoryModel copyWith({
    int? id,
    String? nameAr,
    String? nameEn,
    int? categoryId,
  }) {
    return EditCategoryModel(
      id: id ?? _id,
      nameAr: nameAr ?? _nameAr,
      nameEn: nameEn ?? _nameEn,
      categoryId: categoryId ?? _categoryId,
    );
  }

  factory EditCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$EditCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$EditCategoryModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory EditCategoryModel.fromString(String jsonString) {
    return EditCategoryModel.fromJson(json.decode(jsonString));
  }
}
