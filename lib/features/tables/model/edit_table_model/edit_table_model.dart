import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'edit_table_model.g.dart';

@JsonSerializable()
@immutable
class EditTableModel {
  const EditTableModel({
    this.id,
    String? tableNumber,
    int? isQrTable,
  })  : _tableNumber = tableNumber,
        _isQrTable = isQrTable;

  final int? id;
  final String? _tableNumber;
  final int? _isQrTable;

  @JsonKey(name: "number_table")
  String get tableNumber {
    if (_tableNumber == null || _tableNumber.isEmpty) {
      throw "table_num_empty".tr();
    }
    return _tableNumber;
  }

  @JsonKey(name: "is_qr_table")
  int get isQrTable {
    return _isQrTable ?? (throw "is_qr_empty".tr());
  }

  EditTableModel copyWith({
    int? id,
    String? tableNumber,
    int? isQrTable,
  }) {
    return EditTableModel(
      id: id ?? this.id,
      tableNumber: tableNumber ?? _tableNumber,
      isQrTable: isQrTable ?? _isQrTable,
    );
  }

  factory EditTableModel.fromJson(Map<String, dynamic> json) =>
      _$EditTableModelFromJson(json);

  Map<String, dynamic> toJson() => _$EditTableModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory EditTableModel.fromString(String jsonString) {
    return EditTableModel.fromJson(json.decode(jsonString));
  }
}
