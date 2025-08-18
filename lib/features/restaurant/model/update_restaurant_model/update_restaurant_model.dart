// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_restaurant_model.g.dart';

@JsonSerializable()
class UpdateRestaurantModel {
  const UpdateRestaurantModel({
    this.nameEn,
    this.nameAr,
    this.backgroundColor,
    this.color,
    this.facebookUrl,
    this.instagramUrl,
    this.whatsappPhone,
    this.noteEn,
    this.noteAr,
    this.messageBad,
    this.messageGood,
    this.messagePerfect,
    this.nameUrl,
    this.consumerSpending,
    this.localAdministration,
    this.reconstruction,
    this.priceKm,
  });

  @JsonKey(name: "name_en")
  final String? nameEn;

  @JsonKey(name: "name_ar")
  final String? nameAr;

  @JsonKey(name: "background_color")
  final String? backgroundColor;

  final String? color;

  @JsonKey(name: "facebook_url")
  final String? facebookUrl;

  @JsonKey(name: "instagram_url")
  final String? instagramUrl;

  @JsonKey(name: "whatsapp_phone")
  final String? whatsappPhone;

  @JsonKey(name: "note_en")
  final String? noteEn;

  @JsonKey(name: "note_ar")
  final String? noteAr;

  @JsonKey(name: "message_bad")
  final String? messageBad;

  @JsonKey(name: "message_good")
  final String? messageGood;

  @JsonKey(name: "message_perfect")
  final String? messagePerfect;

  @JsonKey(name: "name_url")
  final String? nameUrl;

  @JsonKey(name: "consumer_spending")
  final String? consumerSpending;

  @JsonKey(name: "local_administration")
  final String? localAdministration;

  final String? reconstruction;

  @JsonKey(name: "price_km")
  final double? priceKm;

  FormData toFormData() {
    final map = <String, dynamic>{
      if (nameEn != null) 'name_en': nameEn,
      if (nameAr != null) 'name_ar': nameAr,
      if (backgroundColor != null) 'background_color': backgroundColor,
      if (color != null) 'color': color,
      if (facebookUrl != null) 'facebook_url': facebookUrl,
      if (instagramUrl != null) 'instagram_url': instagramUrl,
      if (whatsappPhone != null) 'whatsapp_phone': whatsappPhone,
      if (noteEn != null) 'note_en': noteEn,
      if (noteAr != null) 'note_ar': noteAr,
      if (messageBad != null) 'message_bad': messageBad,
      if (messageGood != null) 'message_good': messageGood,
      if (messagePerfect != null) 'message_perfect': messagePerfect,
      if (nameUrl != null) 'name_url': nameUrl,
      if (consumerSpending != null) 'consumer_spending': consumerSpending,
      if (localAdministration != null) 'local_administration': localAdministration,
      if (reconstruction != null) 'reconstruction': reconstruction,
    };

    if (priceKm != null) {
      map['price_km'] = priceKm.toString();
    }

    return FormData.fromMap(map);
  }

  factory UpdateRestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateRestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateRestaurantModelToJson(this);

  @override
  String toString() => jsonEncode(toJson());

  factory UpdateRestaurantModel.fromString(String jsonString) =>
      UpdateRestaurantModel.fromJson(json.decode(jsonString));

  UpdateRestaurantModel copyWith({
    String? nameEn,
    String? nameAr,
    String? backgroundColor,
    String? color,
    String? facebookUrl,
    String? instagramUrl,
    String? whatsappPhone,
    String? noteEn,
    String? noteAr,
    String? messageBad,
    String? messageGood,
    String? messagePerfect,
    String? consumerSpending,
    String? localAdministration,
    String? reconstruction,
    double? priceKm,
    String? nameUrl,
  }) {
    return UpdateRestaurantModel(
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      color: color ?? this.color,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      whatsappPhone: whatsappPhone ?? this.whatsappPhone,
      noteEn: noteEn ?? this.noteEn,
      noteAr: noteAr ?? this.noteAr,
      messageBad: messageBad ?? this.messageBad,
      messageGood: messageGood ?? this.messageGood,
      messagePerfect: messagePerfect ?? this.messagePerfect,
      nameUrl: nameUrl ?? this.nameUrl,
      consumerSpending: consumerSpending ?? this.consumerSpending,
      localAdministration: localAdministration ?? this.localAdministration,
      reconstruction: reconstruction ?? this.reconstruction,
      priceKm: priceKm ?? this.priceKm,
    );
  }
}
