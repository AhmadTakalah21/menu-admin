import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:user_admin/global/utils/json_converters/bool_converter.dart';
import 'package:user_admin/global/utils/json_converters/int_converter.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

part 'table_model.g.dart';

@JsonSerializable()
@immutable
class TableModel implements DropDownItemModel, DeleteModel {
  const TableModel({
    required this.id,
    required this.tableNumber,
    required this.number,
    required this.waiter,
    required this.arakel,
    required this.invoice,
    required this.newOrder,
    required this.isQrTable,
    required this.tableStatus,
    this.qrCode,
  });

  @override
  final int id;

  @IntConverter()
  @JsonKey(name: "number_table")
  final int tableNumber;

  @IntConverter()
  @JsonKey(name: "num")
  final int number;

  @BoolConverter()
  final bool waiter;

  @BoolConverter()
  final bool arakel;

  @BoolConverter()
  final bool invoice;

  @BoolConverter()
  @JsonKey(name: "new_order")
  final bool newOrder;

  @BoolConverter()
  @JsonKey(name: "is_qr_table")
  final bool isQrTable;

  @JsonKey(name: "new")
  final int tableStatus;

  @JsonKey(name: "qr_code")
  final String? qrCode;

  Map<String, dynamic> toJson() => _$TableModelToJson(this);

  factory TableModel.fromJson(Map<String, dynamic> json) =>
      _$TableModelFromJson(json);

  @override
  String get displayName => tableNumber.toString();

  @override
  String get apiDeactivateUrl => "";

  @override
  String get apiDeleteUrl => "delete_table?id=$id";

  @override
  bool get isActive => true;
}
