import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';

part 'service_model.g.dart';

@JsonSerializable()
@immutable
class ServiceModel implements DeleteModel,DropDownItemModel {
  const ServiceModel({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.nameAr,
    required this.price,
  });

  @override
  final int id;
  final String name;
  @JsonKey(name: 'name_en')
  final String nameEn;
  @JsonKey(name: 'name_ar')
  final String nameAr;
  final int price;

  factory ServiceModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory ServiceModel.fromString(String jsonString) {
    return ServiceModel.fromJson(json.decode(jsonString));
  }

  @override
  String get apiDeactivateUrl => "";

  @override
  String get apiDeleteUrl => "delete_service?id=$id";

  @override
  bool get isActive => true;
  
  @override
  String get displayName => name;
}
