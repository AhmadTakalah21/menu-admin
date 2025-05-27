import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'add_service_to_order_model.g.dart';

@JsonSerializable()
@immutable
class AddServiceToOrderModel {
  const AddServiceToOrderModel({
    this.invoiceId,
    this.tableId,
    String? count,
    int? id,
  })  : _count = count,
        _id = id;

  final String? _count;
  final int? _id;

  @JsonKey(name: "invoice_id")
  final int? invoiceId;

  @JsonKey(name: "table_id")
  final int? tableId;

  String get count {
    if (_count == null || _count.isEmpty) {
      throw "quantity_empty".tr();
    }
    return _count;
  }

  @JsonKey(name: "service_id")
  int get id {
    return _id ?? (throw "service_id_empty".tr());
  }


  AddServiceToOrderModel copyWith({
    String? count,
    int? id,
    int? tableId,
    int? invoiceId,
  }) {
    return AddServiceToOrderModel(
      count: count ?? _count,
      //id: id ?? _id,
      id: id,
      tableId: tableId ?? this.tableId,
      invoiceId: invoiceId ?? this.invoiceId,
    );
  }

  factory AddServiceToOrderModel.fromJson(Map<String, dynamic> json) =>
      _$AddServiceToOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddServiceToOrderModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory AddServiceToOrderModel.fromString(String jsonString) {
    return AddServiceToOrderModel.fromJson(json.decode(jsonString));
  }
}
