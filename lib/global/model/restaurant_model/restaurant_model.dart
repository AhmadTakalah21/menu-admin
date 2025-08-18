// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:user_admin/global/utils/json_converters/color_converter.dart';

import '../../utils/json_converters/bool_num_converter.dart';
import '../../utils/json_converters/date_ymd_converter.dart';
import '../../utils/json_converters/double_or_string_converter.dart';
import '../../utils/json_converters/int_or_string_converter.dart';

part 'restaurant_model.g.dart';

@JsonSerializable(explicitToJson: true)
@immutable
class RestaurantModel {
  const RestaurantModel({
    required this.id,

    // نصوص عامة
    this.name,
    this.note,
    this.nameEn,
    this.nameAr,
    this.noteEn,
    this.noteAr,
    this.nameUrl,
    this.facebookUrl,
    this.instagramUrl,
    this.whatsappPhone,

    // تواريخ
    this.endDate,

    // رسائل
    this.messageBad,
    this.messageGood,
    this.messagePerfect,
    this.welcome,
    this.question,
    this.ifAnswerNo,
    this.birthdayMessage,
    this.messageInHomePage,

    // صور وروابط
    this.cover,
    required this.logo,
    this.logoHomePage,
    this.backgroundImageHomePage,
    this.backgroundImageCategory,
    this.backgroundImageSub,
    this.backgroundImageItem,
    this.emptyImage,

    // ألوان
    required this.color,
    required this.backgroundColor,
    required this.fColorCategory,
    required this.fColorSub,
    required this.fColorItem,
    required this.fColorRating,

    // إعدادات خطوط/قياسات (قد تأتي كسلاسل)
    this.font,
    this.fontIdEn,
    this.fontIdAr,
    this.consumerSpending,
    this.localAdmin,
    this.reconstruction,
    this.isAdvertisement,
    this.isNews,
    this.isRate,
    this.rateFormat,
    this.isActive,
    this.isTable,
    this.visited,
    this.isOrder,
    this.isTaxes,
    this.cityId,
    this.emojiId,
    this.menuTemplateId,
    this.superAdminId,
    this.isWelcomeMassege,

    // إحداثيات
    this.latitude,
    this.longitude,

    this.isSubMove,
    this.isDelivery,
    this.isTakeout,
    this.imageOrColor,
    this.qrOffline,
    this.qrTakeout,
    this.rateOpacity,
    this.subOpacity,
    this.imageOrWrite,
    this.exchangeRate,
    this.logoShape,
    this.showMoreThanOnePrice,
    this.favLang,
    this.fontSizeWelcome,
    this.fontTypeWelcome,
    this.fontSizeCategory,
    this.fontTypeCategoryEn,
    this.fontTypeCategoryAr,
    this.fontSizeItem,
    this.fontTypeItemEn,
    this.fontTypeItemAr,
    this.fontBoldCategory,
    this.fontBoldItem,
    this.homeOpacity,
    this.priceKm,
    this.priceType,
    this.shareItemWhatsapp,
    this.adminId,
    this.translations,
  });

  // ===== الحقول =====
  final int id;

  // نصوص عامة
  final String? name;
  final String? note;
  @JsonKey(name: 'name_en')
  final String? nameEn;
  @JsonKey(name: 'name_ar')
  final String? nameAr;
  @JsonKey(name: 'note_en')
  final String? noteEn;
  @JsonKey(name: 'note_ar')
  final String? noteAr;
  @JsonKey(name: 'name_url')
  final String? nameUrl;
  @JsonKey(name: 'facebook_url')
  final String? facebookUrl;
  @JsonKey(name: 'instagram_url')
  final String? instagramUrl;
  @JsonKey(name: 'whatsapp_phone')
  final String? whatsappPhone;

  // تواريخ
  @DateYMDConverter()
  @JsonKey(name: 'end_date')
  final DateTime? endDate;

  // رسائل
  @JsonKey(name: 'message_bad')
  final String? messageBad;
  @JsonKey(name: 'message_good')
  final String? messageGood;
  @JsonKey(name: 'message_perfect')
  final String? messagePerfect;
  final String? welcome;
  final String? question;
  @JsonKey(name: 'if_answer_no')
  final String? ifAnswerNo;
  @JsonKey(name: 'birthday_message')
  final String? birthdayMessage;
  @JsonKey(name: 'message_in_home_page')
  final String? messageInHomePage;

  // صور وروابط
  final String? cover;
  final String logo;
  @JsonKey(name: 'logo_home_page')
  final String? logoHomePage;
  @JsonKey(name: 'background_image_home_page')
  final String? backgroundImageHomePage;
  @JsonKey(name: 'background_image_category')
  final String? backgroundImageCategory;
  @JsonKey(name: 'background_image_sub')
  final String? backgroundImageSub;
  @JsonKey(name: 'background_image_item')
  final String? backgroundImageItem;
  @JsonKey(name: 'empty_image')
  final String? emptyImage;

  // ألوان
  @ColorConverter()
  final Color color;
  @JsonKey(name: 'background_color')
  @ColorConverter()
  final Color backgroundColor;
  @JsonKey(name: 'f_color_category')
  @ColorConverter()
  final Color fColorCategory;
  @JsonKey(name: 'f_color_sub')
  @ColorConverter()
  final Color fColorSub;
  @JsonKey(name: 'f_color_item')
  @ColorConverter()
  final Color fColorItem;
  @JsonKey(name: 'f_color_rating')
  @ColorConverter()
  final Color fColorRating;

  // إعدادات وخيارات
  @JsonKey(name: 'font_id_en')
  final int? fontIdEn;
  @JsonKey(name: 'font_id_ar')
  final int? fontIdAr;
  @JsonKey(name: 'consumer_spending')
  final int? consumerSpending;
  @JsonKey(name: 'local_administration')
  final int? localAdmin;
  final int? reconstruction;

  @JsonKey(name: 'is_advertisement')
  @BoolNumConverter()
  final bool? isAdvertisement;
  @JsonKey(name: 'is_news')
  @BoolNumConverter()
  final bool? isNews;
  @JsonKey(name: 'is_rate')
  @BoolNumConverter()
  final bool? isRate;
  @JsonKey(name: 'rate_format')
  final int? rateFormat;
  @JsonKey(name: 'is_active')
  @BoolNumConverter()
  final bool? isActive;
  @JsonKey(name: 'is_table')
  @BoolNumConverter()
  final bool? isTable;
  final int? visited;
  @JsonKey(name: 'is_order')
  @BoolNumConverter()
  final bool? isOrder;
  @JsonKey(name: 'is_taxes')
  @BoolNumConverter()
  final bool? isTaxes;

  @JsonKey(name: 'city_id')
  final int? cityId;
  @JsonKey(name: 'emoji_id')
  final int? emojiId;
  @JsonKey(name: 'menu_template_id')
  final int? menuTemplateId;
  @JsonKey(name: 'super_admin_id')
  final int? superAdminId;

  @JsonKey(name: 'is_welcome_massege')
  @BoolNumConverter()
  final bool? isWelcomeMassege;

  // إحداثيات (قد تأتي null أو كنص/رقم)
  @DoubleOrStringConverter()
  final double? latitude;
  @DoubleOrStringConverter()
  final double? longitude;

  @JsonKey(name: 'is_sub_move')
  @BoolNumConverter()
  final bool? isSubMove;
  @JsonKey(name: 'is_delivery')
  @BoolNumConverter()
  final bool? isDelivery;
  @JsonKey(name: 'is_takeout')
  @BoolNumConverter()
  final bool? isTakeout;

  @JsonKey(name: 'image_or_color')
  final int? imageOrColor;
  @JsonKey(name: 'qr_offline')
  final String? qrOffline;
  @JsonKey(name: 'qr_takeout')
  final String? qrTakeout;

  @JsonKey(name: 'rate_opacity')
  @IntOrStringConverter()
  final int? rateOpacity;
  @JsonKey(name: 'sub_opacity')
  @DoubleOrStringConverter()
  final double? subOpacity;

  @JsonKey(name: 'image_or_write')
  final int? imageOrWrite;
  @JsonKey(name: 'exchange_rate')
  @DoubleOrStringConverter()
  final double? exchangeRate;
  @JsonKey(name: 'logo_shape')
  @IntOrStringConverter()
  final int? logoShape;
  @JsonKey(name: 'show_more_than_one_price')
  @IntOrStringConverter()
  final int? showMoreThanOnePrice;

  @JsonKey(name: 'fav_lang')
  @IntOrStringConverter()
  final int? favLang;

  final String? font;
  @JsonKey(name: 'font_size_welcome')
  @IntOrStringConverter()
  final int? fontSizeWelcome;
  @JsonKey(name: 'font_type_welcome')
  @IntOrStringConverter()
  final int? fontTypeWelcome;
  @JsonKey(name: 'font_size_category')
  @IntOrStringConverter()
  final int? fontSizeCategory;
  @JsonKey(name: 'font_type_category_en')
  @IntOrStringConverter()
  final int? fontTypeCategoryEn;
  @JsonKey(name: 'font_type_category_ar')
  @IntOrStringConverter()
  final int? fontTypeCategoryAr;
  @JsonKey(name: 'font_size_item')
  @IntOrStringConverter()
  final int? fontSizeItem;
  @JsonKey(name: 'font_type_item_en')
  @IntOrStringConverter()
  final int? fontTypeItemEn;
  @JsonKey(name: 'font_type_item_ar')
  @IntOrStringConverter()
  final int? fontTypeItemAr;
  @JsonKey(name: 'font_bold_category')
  @IntOrStringConverter()
  final int? fontBoldCategory;
  @JsonKey(name: 'font_bold_item')
  @IntOrStringConverter()
  final int? fontBoldItem;

  @JsonKey(name: 'home_opacity')
  @IntOrStringConverter()
  final int? homeOpacity;

  @JsonKey(name: 'price_km')
  @DoubleOrStringConverter()
  final double? priceKm;
  @JsonKey(name: 'price_type')
  final String? priceType;
  @JsonKey(name: 'share_item_whatsapp')
  final String? shareItemWhatsapp;
  @JsonKey(name: 'admin_id')
  final int? adminId;

  // ترجمات مرنة
  final Map<String, dynamic>? translations;

  // ===== JSON =====
  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  // ===== Helpers =====
  @override
  String toString() => jsonEncode(toJson());

  factory RestaurantModel.fromString(String jsonString) =>
      RestaurantModel.fromJson(json.decode(jsonString) as Map<String, dynamic>);
}
