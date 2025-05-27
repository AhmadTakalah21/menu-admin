import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_admin/global/utils/json_converters/bool_converter.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';

part 'coupon_model.g.dart';

@JsonSerializable()
@immutable
class CouponModel implements DeleteModel{
  const CouponModel({
    required this.id,
    required this.code,
    required this.fromDate,
    required this.toDate,
    required this.type,
    required this.percent,
    required this.isActive,
    required this.restaurantId,
  });

  final int id;
  final String code;

  @JsonKey(name: 'from_date')
  final String fromDate;

  @JsonKey(name: 'to_date')
  final String toDate;

  final String type;
  final int percent;

  @override
  @BoolConverter()
  @JsonKey(name: 'is_active')
  final bool isActive;

  @JsonKey(name: 'restaurant_id')
  final int restaurantId;

  factory CouponModel.fromJson(Map<String, dynamic> json) =>
      _$CouponModelFromJson(json);

  Map<String, dynamic> toJson() => _$CouponModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory CouponModel.fromString(String jsonString) {
    return CouponModel.fromJson(json.decode(jsonString));
  }
  
  @override
  String get apiDeactivateUrl => "deactivate_coupon?id=$id";
  
  @override
  String get apiDeleteUrl => "delete_coupon?id=$id";
}