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
    this.count,
    this.serviceId,
  });

  @JsonKey(name: "invoice_id")
  final int? invoiceId;

  @JsonKey(name: "table_id")
  final int? tableId;

  final String? count;

  @JsonKey(name: "service_id")
  final int? serviceId;

  String get safeCount {
    if (count == null || count!.isEmpty) {
      throw Exception("quantity_empty".tr());
    }
    return count!;
  }

  int get safeServiceId =>
      serviceId ?? (throw Exception("service_id_empty".tr()));

  AddServiceToOrderModel copyWith({
    String? count,
    int? serviceId,
    int? tableId,
    int? invoiceId,
  }) {
    return AddServiceToOrderModel(
      count: count ?? this.count,
      serviceId: serviceId ?? this.serviceId,
      tableId: tableId ?? this.tableId,
      invoiceId: invoiceId ?? this.invoiceId,
    );
  }

  factory AddServiceToOrderModel.fromJson(Map<String, dynamic> json) =>
      _$AddServiceToOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddServiceToOrderModelToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}
