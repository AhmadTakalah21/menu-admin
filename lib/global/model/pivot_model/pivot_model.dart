import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pivot_model.g.dart';

@JsonSerializable()
@immutable
class PivotModel {
  const PivotModel({
    required this.modelType,
    required this.modelId,
    this.roleId,
    this.permissionId,
  });

  @JsonKey(name: "model_type")
  final String modelType;

  @JsonKey(name: "model_id" , )
  final int modelId;

  @JsonKey(name: "role_id")
  final int? roleId;

  @JsonKey(name: "permission_id")
  final int? permissionId;

  Map<String, dynamic> toJson() => _$PivotModelToJson(this);

  factory PivotModel.fromJson(Map<String, dynamic> json) =>
      _$PivotModelFromJson(json);

      @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory PivotModel.fromString(String jsonString) {
    return PivotModel.fromJson(json.decode(jsonString));
  }
}
