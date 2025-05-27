import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'package:user_admin/features/home/view/widgets/category_tile.dart';
import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/global/utils/json_converters/bool_converter.dart';
import 'package:user_admin/global/utils/json_converters/int_converter.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel implements DeleteModel, DropDownItemModel, ItemTileModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.nameEn,
    required this.image,
    required this.isActive,
    required this.index,
    this.categoryId,
    required this.content,
    this.subCategories = const [],
    this.items = const [],
  });

  @override
  final int id;

  final String name;

  @override
  @JsonKey(name: "name_ar")
  final String nameAr;

  @override
  @JsonKey(name: "name_en")
  final String nameEn;

  @override
  final String image;

  @override
  @BoolConverter()
  @JsonKey(name: "is_active")
  final bool isActive;

  final int index;

  @NullableIntConverter()
  @JsonKey(name: "category_id")
  final int? categoryId;

  final int content;

  @JsonKey(name: "sub_category")
  final List<CategoryModel> subCategories;

  final List<ItemModel> items;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory CategoryModel.fromString(String jsonString) {
    return CategoryModel.fromJson(json.decode(jsonString));
  }

  @override
  String get displayName => name;

  @override
  String get apiDeleteUrl => "delete_category?id=$id";

  @override
  String get apiDeactivateUrl => "deactivate_category?id=$id";
}
