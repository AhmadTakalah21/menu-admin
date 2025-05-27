import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'add_service_model.g.dart';

@JsonSerializable()
@immutable
class AddServiceModel {
  const AddServiceModel({
    this.id,
    String? nameEn,
    String? nameAr,
    String? price,
  })  : _nameEn = nameEn,
        _nameAr = nameAr,
        _price = price;

  final int? id;
  final String? _nameEn;
  final String? _nameAr;
  final String? _price;

  @JsonKey(name: "name_en")
  String get nameEn {
    if (_nameEn == null || _nameEn.isEmpty) {
      throw "name_en_empty".tr();
    }
    return _nameEn;
  }

  @JsonKey(name: "name_ar")
  String get nameAr {
    if (_nameAr == null || _nameAr.isEmpty) {
      throw "name_ar_empty".tr();
    }
    return _nameAr;
  }

  String get price {
    if (_price == null || _price.isEmpty) {
      throw "price_empty".tr();
    }
    return _price;
  }

  AddServiceModel copyWith({
    int? id,
    String? nameEn,
    String? nameAr,
    String? price,
  }) {
    return AddServiceModel(
      id: id ?? this.id,
      nameEn: nameEn ?? _nameEn,
      nameAr: nameAr ?? _nameAr,
      price: price ?? _price,
    );
  }

  AddServiceModel reset() {
    return const AddServiceModel(
      id: null,
      nameEn: null,
      nameAr: null,
      price: null,
    );
  }

  factory AddServiceModel.fromJson(Map<String, dynamic> json) =>
      _$AddServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddServiceModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory AddServiceModel.fromString(String jsonString) {
    return AddServiceModel.fromJson(json.decode(jsonString));
  }
}
