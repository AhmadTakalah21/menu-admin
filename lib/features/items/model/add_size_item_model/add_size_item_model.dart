import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_size_item_model.g.dart';

@JsonSerializable()
@immutable
class AddSizeItemModel {
  const AddSizeItemModel({
    this.id,
    this.price,
    this.name,
    this.nameEn,
    this.nameAr,
  });

  final int? id;
  final String? price;
  final String? name;

  @JsonKey(name: 'name_en')
  final String? nameEn;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  AddSizeItemModel copyWith({
    int? id,
    String? price,
    String? name,
    String? nameEn,
    String? nameAr,
  }) {
    return AddSizeItemModel(
      id: id ?? this.id,
      price: price ?? this.price,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
    );
  }

  factory AddSizeItemModel.fromJson(Map<String, dynamic> json) =>
      _$AddSizeItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddSizeItemModelToJson(this);
}
