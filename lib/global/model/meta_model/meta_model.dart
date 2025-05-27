import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meta_model.g.dart';

@JsonSerializable()
@immutable
class MetaModel {
  const MetaModel({
    required this.total,
    required this.count,
    required this.perPage,
    required this.currentPage,
    required this.totalPages,
  });

  final int total;
  
  final int count;

  @JsonKey(name: "per_page")
  final int perPage;

  @JsonKey(name: "current_page")
  final int currentPage;

  @JsonKey(name: "total_pages")
  final int totalPages;

  Map<String, dynamic> toJson() => _$MetaModelToJson(this);

  factory MetaModel.fromJson(Map<String, dynamic> json) =>
      _$MetaModelFromJson(json);

      @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory MetaModel.fromString(String jsonString) {
    return MetaModel.fromJson(json.decode(jsonString));
  }
}