// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:user_admin/features/tables/model/order_details_model/order_details_model.dart';
import 'package:user_admin/global/utils/json_converters/string_converter.dart';

part 'drvier_invoice_model.g.dart';

@JsonSerializable()
@immutable
class DrvierInvoiceModel {
  const DrvierInvoiceModel({
    required this.id,
    required this.number,
    required this.createdAt,
    this.customerReceivedAt,
    this.receivedAt,
    this.adminId,
    this.adminName,
    this.customerId,
    this.userId,
    this.user,
    this.username,
    this.userPhone,
    this.deliveryName,
    this.deliveryPhone,
    this.deliveryAddress,
    this.price,
    this.status,
    this.total,
    this.totalWithDeliveryPrice,
    this.discount,
    this.tableId,
    this.tableNumber,
    required this.restaurantId,
    this.restaurantName,
    this.logo,
    this.waiter,
    this.url,
    this.region,
    this.longitude,
    this.latitude,
    this.deliveryPrice,
    required this.orders,
    this.consumerSpending,
    this.localAdministration,
    this.reconstruction,
  });

  final int id;

  @JsonKey(name: 'num')
  final int number;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'customer_received_at')
  final String? customerReceivedAt;

  @JsonKey(name: 'received_at')
  final String? receivedAt;

  @JsonKey(name: 'admin_id')
  final int? adminId;

  @JsonKey(name: 'admin_name')
  final String? adminName;

  @JsonKey(name: 'customer_id')
  final int? customerId;

  @JsonKey(name: 'user_id')
  final int? userId;

  final String? user;
  final String? username;

  @JsonKey(name: 'user_phone')
  final String? userPhone;

  @JsonKey(name: 'delivery_name')
  final String? deliveryName;

  @JsonKey(name: 'delivery_phone')
  final String? deliveryPhone;

  @JsonKey(name: 'delivery_address')
  final String? deliveryAddress;

  @NullableStringConverter()
  final String? price;

  @NullableStringConverter()
  final String? status;

  @NullableStringConverter()
  final String? total;

  @NullableStringConverter()
  @JsonKey(name: 'total_with_delivery_price')
  final String? totalWithDeliveryPrice;

  @NullableStringConverter()
  final String? discount;

  @JsonKey(name: 'table_id')
  final int? tableId;

  @JsonKey(name: 'number_table')
  final int? tableNumber;

  @JsonKey(name: 'restaurant_id')
  final int restaurantId;

  @JsonKey(name: 'restaurant_name')
  final String? restaurantName;

  final String? logo;
  final String? waiter;
  final String? url;
  final String? region;
  final String? longitude;
  final String? latitude;

  @NullableStringConverter()
  @JsonKey(name: 'delivery_price')
  final String? deliveryPrice;

  final List<OrderDetailsModel> orders;

  @NullableStringConverter()
  @JsonKey(name: 'consumer_spending')
  final String? consumerSpending;

  @NullableStringConverter()
  @JsonKey(name: 'local_administration')
  final String? localAdministration;

  @NullableStringConverter()
  final String? reconstruction;

  factory DrvierInvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$DrvierInvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DrvierInvoiceModelToJson(this);

  @override
  String toString() => jsonEncode(toJson());

  factory DrvierInvoiceModel.fromString(String jsonString) =>
      DrvierInvoiceModel.fromJson(json.decode(jsonString));
}
