import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:user_admin/global/utils/json_converters/bool_converter.dart';
import 'package:user_admin/global/utils/json_converters/string_converter.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

part 'driver_model.g.dart';

@JsonSerializable()
@immutable
class DriverModel implements DeleteModel, DropDownItemModel {
  const DriverModel({
    required this.id,
    required this.name,
    required this.username,
    this.email,
    required this.role,
    required this.phone,
    this.gender,
    this.birthday,
    this.address,
    required this.restaurantId,
    this.status,
    required this.isActive,
    this.token,
    required this.image,
    this.restaurantLongitude,
    this.restaurantLatitude,
    this.distance,
    this.longitude,
    this.latitude,
    @Deprecated('لم يعد يستخدم') this.deliveryLongitude,
    @Deprecated('لم يعد يستخدم') this.deliveryLatitude,
    this.invoice = const [],
  });

  @override
  final int id;
  final String name;
  final String username;
  final String? email;
  final int role;
  final String phone;
  final String? gender;
  final String? birthday;
  final String? address;

  @JsonKey(name: 'restaurant_id')
  final int restaurantId;

  final String? status;

  @override
  @BoolConverter()
  @JsonKey(name: 'is_active')
  final bool isActive;

  final String? token;
  final String image;

  // ========== إحداثيات المطعم ==========
  @JsonKey(name: 'restaurant_longitude')
  final String? restaurantLongitude;

  @JsonKey(name: 'restaurant_latitude')
  final String? restaurantLatitude;

  // ========== مسافة السائق (من السيرفر كـ number) ==========
  @JsonKey(fromJson: _toDouble, toJson: _doubleToJson)
  final double? distance; // مثال: 790.15

  // ========== إحداثيات السائق (نصية في الـ API) ==========
  @NullableStringConverter()
  final String? longitude;

  @NullableStringConverter()
  final String? latitude;

  // (حقول قديمة إن وُجدت)
  @JsonKey(name: "delivery_latitude")
  final String? deliveryLatitude;

  @JsonKey(name: "delivery_longitude")
  final String? deliveryLongitude;

  // ========== فواتير السائق (أول عنصر يحوي موقع العميل) ==========
  @JsonKey(defaultValue: [])
  final List<DriverInvoiceLite> invoice;

  // ================== JSON ==================
  factory DriverModel.fromJson(Map<String, dynamic> json) =>
      _$DriverModelFromJson(json);

  Map<String, dynamic> toJson() => _$DriverModelToJson(this);

  @override
  String toString() => jsonEncode(toJson());

  factory DriverModel.fromString(String jsonString) =>
      DriverModel.fromJson(json.decode(jsonString));

  @override
  String get apiDeactivateUrl => "active_delivery?id=$id";

  @override
  String get apiDeleteUrl => "delete_delivery?id=$id";

  @override
  String get displayName {
    final d = distance;
    final dStr = (d == null) ? "unprovided".tr() : d.toStringAsFixed(1);
    return "${"name".tr()}: $name   ${"distance".tr()}: $dStr";
  }

  double? get driverLat => double.tryParse(latitude ?? '');
  double? get driverLon => double.tryParse(longitude ?? '');
  double? get restaurantLat => double.tryParse(restaurantLatitude ?? '');
  double? get restaurantLon => double.tryParse(restaurantLongitude ?? '');

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    final s = v.toString().trim();
    if (s.isEmpty) return null;
    return double.tryParse(s);
  }

  static dynamic _doubleToJson(double? v) => v;
}

@JsonSerializable()
@immutable
class DriverInvoiceLite {
  const DriverInvoiceLite({
    required this.id,
    this.num,
    @JsonKey(name: 'created_at') this.createdAt,
    this.customerReceivedAt,
    this.receivedAt,
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
    this.totalEstimatedDuration,
    this.total,
    @JsonKey(name: 'total_with_delivery_price') this.totalWithDeliveryPrice,
    this.discount,
    this.tableId,
    this.restaurantId,
    this.url,
    this.region,
    this.longitude,
    this.latitude,
    this.deliveryPrice,
    this.distanceKm,
  });

  final int id;
  final int? num;
  final String? createdAt;

  @JsonKey(name: 'customer_received_at')
  final String? customerReceivedAt;

  @JsonKey(name: 'received_at')
  final String? receivedAt;

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

  final String? price;

  final String? status;

  @JsonKey(name: 'total_estimated_duration')
  final int? totalEstimatedDuration;

  final String? total;

  @JsonKey(name: 'total_with_delivery_price')
  final String? totalWithDeliveryPrice;

  final String? discount;

  @JsonKey(name: 'table_id')
  final int? tableId;

  @JsonKey(name: 'restaurant_id')
  final int? restaurantId;

  final String? url;
  final String? region;

  final String? longitude;
  final String? latitude;

  @JsonKey(name: 'delivery_price')
  final double? deliveryPrice;

  @JsonKey(name: 'distance_km')
  final double? distanceKm;

  factory DriverInvoiceLite.fromJson(Map<String, dynamic> json) =>
      _$DriverInvoiceLiteFromJson(json);

  Map<String, dynamic> toJson() => _$DriverInvoiceLiteToJson(this);

  // Getters مساعدة
  double? get lat => double.tryParse(latitude ?? '');
  double? get lon => double.tryParse(longitude ?? '');
}
