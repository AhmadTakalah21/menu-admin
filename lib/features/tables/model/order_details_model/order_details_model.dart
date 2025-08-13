import 'package:json_annotation/json_annotation.dart';

import 'package:user_admin/global/widgets/insure_delete_widget.dart';

part 'order_details_model.g.dart';

@JsonSerializable()
class OrderDetailsModel implements DeleteModel {
  OrderDetailsModel({
    this.id,
    this.itemId,
    required this.name,
    this.type,
    this.nameEn,
    this.nameAr,
    this.typeEn,
    this.typeAr,
    required this.price,
    required this.count,
    this.total,
    this.tableId,
    this.customerId,
    this.userId,
    this.tableNumber,
    required this.status,
    required this.createdAt,
    this.invoiceId,
  });

  final int? id;

  @JsonKey(name: "item_id")
  final int? itemId;

  final String name;

  final String? type;

  @JsonKey(name: "name_en")
  final String? nameEn;

  @JsonKey(name: "name_ar")
  final String? nameAr;

  @JsonKey(name: "type_en")
  final String? typeEn;

  @JsonKey(name: "type_ar")
  final String? typeAr;

  final int price;

  final int count;

  final int? total;

  @JsonKey(name: "table_id")
  final int? tableId;

  @JsonKey(name: "customer_id")
  final int? customerId;

  @JsonKey(name: "user_id")
  final int? userId;

  @JsonKey(name: "number_table")
  final int? tableNumber;

  final String status;

  @JsonKey(name: "created_at")
  final String createdAt;

  @JsonKey(name: "invoice_id")
  final int? invoiceId;

  Map<String, dynamic> toJson() => _$OrderDetailsModelToJson(this);

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsModelFromJson(json);

  @override
  String get apiDeactivateUrl => "";

  @override
  String get apiDeleteUrl => 'delete_order?id=$id';

  @override
  bool get isActive => true;
}
