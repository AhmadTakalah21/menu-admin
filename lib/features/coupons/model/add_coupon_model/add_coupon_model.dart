import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_coupon_model.g.dart';

@JsonSerializable()
@immutable
class AddCouponModel {
  const AddCouponModel({
    this.id,
    this.code,
    String? fromDate,
    String? toDate,
    String? percent,
  })  : _fromDate = fromDate,
        _toDate = toDate,
        _percent = percent;

  final int? id;
  final String? code;
  final String? _fromDate;
  final String? _toDate;
  final String? _percent;

  @JsonKey(name: "from_date")
  String? get fromDate => _fromDate;

  @JsonKey(name: "to_date")
  String? get toDate => _toDate;

  String? get percent => _percent;

  /// دالة تحقق من القيم المطلوبة
  void validateFields() {
    if (_fromDate == null || _fromDate.isEmpty) {
      throw "from_date_empty".tr();
    }
    if (_toDate == null || _toDate.isEmpty) {
      throw "to_date_empty".tr();
    }
    if (_percent == null || _percent.isEmpty) {
      throw "percent_empty".tr();
    }
  }

  /// تحقق فقط من الكود
  bool validateCode() {
    final code = this.code;
    return code != null && code.isNotEmpty;
  }

  AddCouponModel copyWith({
    int? id,
    String? fromDate,
    String? code,
    String? toDate,
    String? percent,
  }) {
    return AddCouponModel(
      id: id ?? this.id,
      code: code ?? this.code,
      fromDate: fromDate ?? _fromDate,
      toDate: toDate ?? _toDate,
      percent: percent ?? _percent,
    );
  }

  factory AddCouponModel.fromJson(Map<String, dynamic> json) =>
      _$AddCouponModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddCouponModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory AddCouponModel.fromString(String jsonString) {
    return AddCouponModel.fromJson(json.decode(jsonString));
  }
}
