import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
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
    this.itemId,
    this.descriptionAr,
    this.descriptionEn,
    this.image,
    this.localImage,
  });

  final int? id;
  final String? price;
  final String? name;

  @JsonKey(name: 'name_en')
  final String? nameEn;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  @JsonKey(name: "description_ar")
  final String? descriptionAr;

  @JsonKey(name: "description_en")
  final String? descriptionEn;

  final String? image;

  final int? itemId;

  @JsonKey(ignore: true)
  final XFile? localImage;

  AddSizeItemModel copyWith({
    int? id,
    String? price,
    String? name,
    String? nameEn,
    String? nameAr,
    int? itemId,
    String? descriptionAr,
    String? descriptionEn,
    String? image,
    XFile? localImage,
  }) {
    return AddSizeItemModel(
      id: id ?? this.id,
      price: price ?? this.price,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      itemId: itemId ?? this.itemId,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      image: image ?? this.image,
      localImage: localImage ?? this.localImage,
    );
  }

  factory AddSizeItemModel.fromJson(Map<String, dynamic> json) =>
      _$AddSizeItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddSizeItemModelToJson(this);
}
