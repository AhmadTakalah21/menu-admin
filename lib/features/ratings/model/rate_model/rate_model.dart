import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'rate_model.g.dart';

@JsonSerializable()
@immutable
class RateModel {
  const RateModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.phone,
    required this.birthday,
    required this.gender,
    required this.restaurant,
    required this.rate,
    required this.note,
  });

  final int id;

  @JsonKey(name: 'restaurant_id')
  final int restaurantId;

  final String name;
  final String phone;
  final int birthday;
  final String gender;
  final String restaurant;
  final int rate;
  final String note;

  factory RateModel.fromJson(Map<String, dynamic> json) =>
      _$RateModelFromJson(json);

  Map<String, dynamic> toJson() => _$RateModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory RateModel.fromString(String jsonString) {
    return RateModel.fromJson(json.decode(jsonString));
  }
}
