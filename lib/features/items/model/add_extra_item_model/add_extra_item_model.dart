import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_extra_item_model.g.dart';

@JsonSerializable()
@immutable
class AddExtraItemModel {
  const AddExtraItemModel({
    this.id,
    this.price,
    this.icon,
    this.name,
    this.nameEn,
    this.nameAr,
    this.itemId,
    this.localImage,
  });

  final int? id;
  final String? price;
  final String? icon;
  final String? name;

  @JsonKey(name: 'name_en')
  final String? nameEn;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  final int? itemId;

  @JsonKey(ignore: true)
  final XFile? localImage;

  AddExtraItemModel copyWith({
    int? id,
    String? price,
    String? icon,
    String? name,
    String? nameEn,
    String? nameAr,
    int? itemId,
    XFile? localImage,
  }) {
    return AddExtraItemModel(
      id: id ?? this.id,
      price: price ?? this.price,
      icon: icon ?? this.icon,
      name: name ?? this.name,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      itemId: itemId ?? this.itemId,
      localImage: localImage ?? this.localImage,
    );
  }

  factory AddExtraItemModel.fromJson(Map<String, dynamic> json) =>
      _$AddExtraItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddExtraItemModelToJson(this);
}
