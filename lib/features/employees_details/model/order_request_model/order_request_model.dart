import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'order_request_model.g.dart';

@JsonSerializable()
@immutable
class OrderRequestModel {
  const OrderRequestModel({
    required this.id,
    required this.responseTime,
    required this.tableId,
    required this.numberTable,
    required this.employeeId,
    required this.name,
    required this.type,
    required this.adminId,
  });
  
  final int id;
  @JsonKey(name: 'response_time')
  final String responseTime;
  @JsonKey(name: 'table_id')
  final int tableId;
  @JsonKey(name: 'number_table')
  final int numberTable;
  @JsonKey(name: 'employee_id')
  final int employeeId;
  final String name;
  final String type;
  @JsonKey(name: 'admin_id')
  final int adminId;

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$OrderRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderRequestModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory OrderRequestModel.fromString(String jsonString) {
    return OrderRequestModel.fromJson(json.decode(jsonString));
  }
}
