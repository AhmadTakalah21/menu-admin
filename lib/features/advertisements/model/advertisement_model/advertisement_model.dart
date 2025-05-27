import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';

part 'advertisement_model.g.dart';

@JsonSerializable()
class AdvertisementModel implements DeleteModel{
  AdvertisementModel({
    required this.id,
    required this.image,
    required this.title,
    required this.restaurant,
    required this.fromDate,
    required this.toDate,
    required this.isPanorama,
    required this.hideDate,
  });

  final int id;

  final String image;

  final String title;

  final String restaurant;

  @JsonKey(name: "from_date")
  final String fromDate;

  @JsonKey(name: "to_date")
  final String toDate;

  @JsonKey(name: "is_panorama")
  final int isPanorama;

  @JsonKey(name: "hide_date")
  final int hideDate;

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) =>
      _$AdvertisementModelFromJson(json);

  Map<String, dynamic> toJson() => _$AdvertisementModelToJson(this);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory AdvertisementModel.fromString(String jsonString) {
    return AdvertisementModel.fromJson(json.decode(jsonString));
  }
  
  @override
  String get apiDeactivateUrl => "";
  
  @override
  String get apiDeleteUrl => "delete_advertisement?id=$id";
  
  @override
  bool get isActive => true;
}
