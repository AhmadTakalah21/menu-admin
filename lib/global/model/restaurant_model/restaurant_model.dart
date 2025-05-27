// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:user_admin/global/utils/json_converters/color_converter.dart';

part 'restaurant_model.g.dart';

@JsonSerializable()
@immutable
class RestaurantModel {
  const RestaurantModel({
    required this.id,
    required this.name,
    required this.note,
    required this.nameEn,
    required this.nameAr,
    required this.noteEn,
    required this.noteAr,
    required this.nameUrl,
    this.facebookUrl,
    this.instagramUrl,
    this.whatsappPhone,
    required this.endDate,
    this.messageBad,
    this.messageGood,
    this.messagePerfect,
    required this.cover,
    required this.logo,
    this.color,
    this.backgroundColor,
    this.fColorCategory,
    this.fColorSub,
    this.fColorItem,
    this.fColorRating,
    required this.fontIdEn,
    required this.fontIdAr,
    required this.consumerSpending,
    required this.localAdmin,
    required this.reconstruction,
    required this.isAdv,
    required this.isNews,
    required this.isRate,
    required this.rateFormat,
    required this.isActive,
    required this.isTable,
    required this.visited,
    required this.isOrder,
    required this.isTaxes,
    required this.cityId,
    required this.emojiId,
    required this.menuTemplateId,
    required this.superAdminId,
    required this.isWelcomeMassege,
    required this.welcome,
    required this.question,
    required this.ifAnswerNo,
    this.latitude,
    this.longitude,
    required this.isSubMove,
    required this.isDelivery,
    required this.isTakeout,
    this.birthdayMessage,
    required this.imageOrColor,
    this.qrOffline,
    this.qrTakeout,
    this.backgroundImageHomePage,
    this.backgroundImageCategory,
    this.backgroundImageSub,
    this.backgroundImageItem,
    this.rateOpacity,
    this.subOpacity,
    required this.imageOrWrite,
    this.exchangeRate,
    required this.logoShape,
    required this.showMoreThanOnePrice,
    required this.messageInHomePage,
    required this.logoHomePage,
    required this.favLang,
    this.fontSizeWelcome,
    this.fontTypeWelcome,
    this.fontSizeCategory,
    required this.fontTypeCategoryEn,
    required this.fontTypeCategoryAr,
    this.fontSizeItem,
    required this.fontTypeItemEn,
    required this.fontTypeItemAr,
    this.fontBoldCategory,
    this.fontBoldItem,
    required this.emptyImage,
    this.homeOpacity,
    required this.priceKm,
    required this.priceType,
    required this.shareItemWhatsapp,
    this.adminId,
  });

  final int id;
  final String name;
  final String note;
  @JsonKey(name: "name_en")
  final String nameEn;
  @JsonKey(name: "name_ar")
  final String nameAr;
  @JsonKey(name: "note_en")
  final String noteEn;
  @JsonKey(name: "note_ar")
  final String noteAr;
  @JsonKey(name: "name_url")
  final String nameUrl;
  @JsonKey(name: "facebook_url")
  final String? facebookUrl;
  @JsonKey(name: "instagram_url")
  final String? instagramUrl;
  @JsonKey(name: "whatsapp_phone")
  final String? whatsappPhone;
  @JsonKey(name: "end_date")
  final String endDate;
  @JsonKey(name: "message_bad")
  final String? messageBad;
  @JsonKey(name: "message_good")
  final String? messageGood;
  @JsonKey(name: "message_perfect")
  final String? messagePerfect;
  final String cover;
  final String logo;
  @ColorConverter()
  final Color? color;
  @ColorConverter()
  @JsonKey(name: "background_color")
  final Color? backgroundColor;
  @ColorConverter()
  @JsonKey(name: "f_color_category")
  final Color? fColorCategory;
  @ColorConverter()
  @JsonKey(name: "f_color_sub")
  final Color? fColorSub;
  @ColorConverter()
  @JsonKey(name: "f_color_item")
  final Color? fColorItem;
  @ColorConverter()
  @JsonKey(name: "f_color_rating")
  final Color? fColorRating;
  @JsonKey(name: "font_id_en")
  final int fontIdEn;
  @JsonKey(name: "font_id_ar")
  final int fontIdAr;
  @JsonKey(name: "consumer_spending")
  final int consumerSpending;
  @JsonKey(name: "local_administration")
  final int localAdmin;
  final int reconstruction;
  @JsonKey(name: "is_advertisement")
  final int isAdv;
  @JsonKey(name: "is_news")
  final int isNews;
  @JsonKey(name: "is_rate")
  final int isRate;
  @JsonKey(name: "rate_format")
  final int rateFormat;
  @JsonKey(name: "is_active")
  final int isActive;
  @JsonKey(name: "is_table")
  final int isTable;
  final int visited;
  @JsonKey(name: "is_order")
  final int isOrder;
  @JsonKey(name: "is_taxes")
  final int isTaxes;
  @JsonKey(name: "city_id")
  final int cityId;
  @JsonKey(name: "emoji_id")
  final int emojiId;
  @JsonKey(name: "menu_template_id")
  final int menuTemplateId;
  @JsonKey(name: "super_admin_id")
  final int superAdminId;
  @JsonKey(name: "is_welcome_massege")
  final int isWelcomeMassege;
  final String welcome;
  final String question;
  @JsonKey(name: "if_answer_no")
  final String ifAnswerNo;
  final String? latitude;
  final String? longitude;
  @JsonKey(name: "is_sub_move")
  final int isSubMove;
  @JsonKey(name: "is_delivery")
  final int isDelivery;
  @JsonKey(name: "is_takeout")
  final int isTakeout;
  @JsonKey(name: "birthday_message")
  final String? birthdayMessage;
  @JsonKey(name: "image_or_color")
  final int imageOrColor;
  @JsonKey(name: "qr_offline")
  final String? qrOffline;
  @JsonKey(name: "qr_takeout")
  final String? qrTakeout;
  @JsonKey(name: "background_image_home_page")
  final String? backgroundImageHomePage;
  @JsonKey(name: "background_image_category")
  final String? backgroundImageCategory;
  @JsonKey(name: "background_image_sub")
  final String? backgroundImageSub;
  @JsonKey(name: "background_image_item")
  final String? backgroundImageItem;
  @JsonKey(name: "rate_opacity")
  final int? rateOpacity;
  @JsonKey(name: "sub_opacity")
  final double? subOpacity;
  @JsonKey(name: "image_or_write")
  final int imageOrWrite;
  @JsonKey(name: "exchange_rate")
  final int? exchangeRate;
  @JsonKey(name: "logo_shape")
  final int logoShape;
  @JsonKey(name: "show_more_than_one_price")
  final int showMoreThanOnePrice;
  @JsonKey(name: "message_in_home_page")
  final String messageInHomePage;
  @JsonKey(name: "logo_home_page")
  final String logoHomePage;
  @JsonKey(name: "fav_lang")
  final String favLang;
  @JsonKey(name: "font_size_welcome")
  final int? fontSizeWelcome;
  @JsonKey(name: "font_type_welcome")
  final int? fontTypeWelcome;
  @JsonKey(name: "font_size_category")
  final int? fontSizeCategory;
  @JsonKey(name: "font_type_category_en")
  final int fontTypeCategoryEn;
  @JsonKey(name: "font_type_category_ar")
  final int fontTypeCategoryAr;
  @JsonKey(name: "font_size_item")
  final int? fontSizeItem;
  @JsonKey(name: "font_type_item_en")
  final int fontTypeItemEn;
  @JsonKey(name: "font_type_item_ar")
  final int fontTypeItemAr;
  @JsonKey(name: "font_bold_category")
  final int? fontBoldCategory;
  @JsonKey(name: "font_bold_item")
  final int? fontBoldItem;
  @JsonKey(name: "empty_image")
  final String emptyImage;
  @JsonKey(name: "home_opacity")
  final int? homeOpacity;
  @JsonKey(name: "price_km")
  final double priceKm;
  @JsonKey(name: "price_type")
  final String priceType;
  @JsonKey(name: "share_item_whatsapp")
  final String shareItemWhatsapp;
  @JsonKey(name: "admin_id")
  final int? adminId;

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory RestaurantModel.fromString(String jsonString) {
    return RestaurantModel.fromJson(json.decode(jsonString));
  }
}
