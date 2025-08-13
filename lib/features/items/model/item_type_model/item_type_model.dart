import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_admin/global/utils/json_converters/string_converter.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

part 'item_type_model.g.dart';

@JsonSerializable()
@immutable
class ItemTypeModel implements DropDownItemModel {
  const ItemTypeModel({
    required this.id,
    this.name,
    @JsonKey(name: "name_en") this.nameEn,
    @JsonKey(name: "name_ar") this.nameAr,
    @StringConverter() this.price,
    this.image,
    this.itemId,
    @JsonKey(name: "description_ar") this.descriptionAr,
    @JsonKey(name: "description_en") this.descriptionEn,
    @JsonKey(name: "status") this.status = 0,
  });

  @override
  final int id;

  @JsonKey(name: "item_id")
  final int? itemId;

  final String? name;

  @JsonKey(name: "name_en")
  final String? nameEn;

  @JsonKey(name: "name_ar")
  final String? nameAr;

  @StringConverter()
  final String? price;

  final String? image;

  @JsonKey(name: "description_ar")
  final String? descriptionAr;

  @JsonKey(name: "description_en")
  final String? descriptionEn;

  final int status;

  bool get isSelectable => status == 1;

  factory ItemTypeModel.fromJson(Map<String, dynamic> json) =>
      _$ItemTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemTypeModelToJson(this);

  @override
  String toString() => jsonEncode(toJson());

  factory ItemTypeModel.fromString(String jsonString) =>
      ItemTypeModel.fromJson(json.decode(jsonString));

  ItemTypeModel copyWith({
    int? id,
    int? itemId,
    String? name,
    String? nameEn,
    String? nameAr,
    String? price,
    String? image,
    String? descriptionAr,
    String? descriptionEn,
    int? status,
  }) {
    return ItemTypeModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      price: price ?? this.price,
      image: image ?? this.image,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      status: status ?? this.status,
    );
  }

  @override
  String get displayName => name ?? '';
}
