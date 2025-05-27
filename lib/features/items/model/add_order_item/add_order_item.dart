import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'add_order_item.g.dart';

@JsonSerializable()
@immutable
class AddOrderItem {
  const AddOrderItem({
    this.id,
    this.status,
    String? count,
  }) : _count = count;

  final int? id;

  final String? _count;

  final String? status;

  String get count {
    if (_count == null || _count.isEmpty) {
      throw "quantity_empty".tr();
    }
    return _count;
  }

  factory AddOrderItem.fromJson(Map<String, dynamic> json) =>
      _$AddOrderItemFromJson(json);

  Map<String, dynamic> toJson() => _$AddOrderItemToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory AddOrderItem.fromString(String jsonString) {
    return AddOrderItem.fromJson(json.decode(jsonString));
  }

  AddOrderItem copyWith({
    int? id,
    String? count,
    String? status,
  }) {
    return AddOrderItem(
      id: id ?? this.id,
      count: count ?? _count,
      status: status ?? this.status,
    );
  }
}
