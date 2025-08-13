import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_advertisement_model.g.dart';

@JsonSerializable()
@immutable
class AddAdvertisementModel {
  const AddAdvertisementModel({
    this.id,
    this.isPanorama = 0,
    this.hideDate = 0,
    String? title,
    String? fromDate,
    String? toDate,
  })  : _title = title,
        _fromDate = fromDate,
        _toDate = toDate;

  final int? id;
  final String? _title;

  @JsonKey(name: "is_panorama")
  final int? isPanorama;

  @JsonKey(name: "hide_date")
  final int? hideDate;

  final String? _fromDate;
  final String? _toDate;

  @JsonKey(name: "title")
  String? get title => _title;

  @JsonKey(name: "from_date")
  String? get fromDate => _fromDate;

  @JsonKey(name: "to_date")
  String? get toDate => _toDate;

  /// ✅ دالة تحقق آمنة من القيم المطلوبة
  void validateFields() {
    if (_title == null || _title!.isEmpty) {
      throw "name_empty".tr();
    }
    if (_fromDate == null || _fromDate!.isEmpty) {
      throw "from_date_empty".tr();
    }
    if (_toDate == null || _toDate!.isEmpty) {
      throw "to_date_empty".tr();
    }
  }

  AddAdvertisementModel copyWith({
    int? id,
    String? title,
    int? isPanorama,
    int? hideDate,
    String? fromDate,
    String? toDate,
  }) {
    return AddAdvertisementModel(
      id: id ?? this.id,
      title: title ?? _title,
      isPanorama: isPanorama ?? this.isPanorama,
      hideDate: hideDate ?? this.hideDate,
      fromDate: fromDate ?? _fromDate,
      toDate: toDate ?? _toDate,
    );
  }

  factory AddAdvertisementModel.fromJson(Map<String, dynamic> json) =>
      _$AddAdvertisementModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddAdvertisementModelToJson(this);

  @override
  String toString() => jsonEncode(toJson());

  factory AddAdvertisementModel.fromString(String jsonString) {
    return AddAdvertisementModel.fromJson(json.decode(jsonString));
  }
}
