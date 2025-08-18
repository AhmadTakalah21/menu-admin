// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantModel _$RestaurantModelFromJson(Map<String, dynamic> json) =>
    RestaurantModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      note: json['note'] as String?,
      nameEn: json['name_en'] as String?,
      nameAr: json['name_ar'] as String?,
      noteEn: json['note_en'] as String?,
      noteAr: json['note_ar'] as String?,
      nameUrl: json['name_url'] as String?,
      facebookUrl: json['facebook_url'] as String?,
      instagramUrl: json['instagram_url'] as String?,
      whatsappPhone: json['whatsapp_phone'] as String?,
      endDate: const DateYMDConverter().fromJson(json['end_date']),
      messageBad: json['message_bad'] as String?,
      messageGood: json['message_good'] as String?,
      messagePerfect: json['message_perfect'] as String?,
      welcome: json['welcome'] as String?,
      question: json['question'] as String?,
      ifAnswerNo: json['if_answer_no'] as String?,
      birthdayMessage: json['birthday_message'] as String?,
      messageInHomePage: json['message_in_home_page'] as String?,
      cover: json['cover'] as String?,
      logo: json['logo'] as String,
      logoHomePage: json['logo_home_page'] as String?,
      backgroundImageHomePage: json['background_image_home_page'] as String?,
      backgroundImageCategory: json['background_image_category'] as String?,
      backgroundImageSub: json['background_image_sub'] as String?,
      backgroundImageItem: json['background_image_item'] as String?,
      emptyImage: json['empty_image'] as String?,
      color: const ColorConverter().fromJson(json['color']),
      backgroundColor:
          const ColorConverter().fromJson(json['background_color']),
      fColorCategory: const ColorConverter().fromJson(json['f_color_category']),
      fColorSub: const ColorConverter().fromJson(json['f_color_sub']),
      fColorItem: const ColorConverter().fromJson(json['f_color_item']),
      fColorRating: const ColorConverter().fromJson(json['f_color_rating']),
      font: json['font'] as String?,
      fontIdEn: (json['font_id_en'] as num?)?.toInt(),
      fontIdAr: (json['font_id_ar'] as num?)?.toInt(),
      consumerSpending: (json['consumer_spending'] as num?)?.toInt(),
      localAdmin: (json['local_administration'] as num?)?.toInt(),
      reconstruction: (json['reconstruction'] as num?)?.toInt(),
      isAdvertisement:
          const BoolNumConverter().fromJson(json['is_advertisement']),
      isNews: const BoolNumConverter().fromJson(json['is_news']),
      isRate: const BoolNumConverter().fromJson(json['is_rate']),
      rateFormat: (json['rate_format'] as num?)?.toInt(),
      isActive: const BoolNumConverter().fromJson(json['is_active']),
      isTable: const BoolNumConverter().fromJson(json['is_table']),
      visited: (json['visited'] as num?)?.toInt(),
      isOrder: const BoolNumConverter().fromJson(json['is_order']),
      isTaxes: const BoolNumConverter().fromJson(json['is_taxes']),
      cityId: (json['city_id'] as num?)?.toInt(),
      emojiId: (json['emoji_id'] as num?)?.toInt(),
      menuTemplateId: (json['menu_template_id'] as num?)?.toInt(),
      superAdminId: (json['super_admin_id'] as num?)?.toInt(),
      isWelcomeMassege:
          const BoolNumConverter().fromJson(json['is_welcome_massege']),
      latitude: const DoubleOrStringConverter().fromJson(json['latitude']),
      longitude: const DoubleOrStringConverter().fromJson(json['longitude']),
      isSubMove: const BoolNumConverter().fromJson(json['is_sub_move']),
      isDelivery: const BoolNumConverter().fromJson(json['is_delivery']),
      isTakeout: const BoolNumConverter().fromJson(json['is_takeout']),
      imageOrColor: (json['image_or_color'] as num?)?.toInt(),
      qrOffline: json['qr_offline'] as String?,
      qrTakeout: json['qr_takeout'] as String?,
      rateOpacity: const IntOrStringConverter().fromJson(json['rate_opacity']),
      subOpacity: const DoubleOrStringConverter().fromJson(json['sub_opacity']),
      imageOrWrite: (json['image_or_write'] as num?)?.toInt(),
      exchangeRate:
          const DoubleOrStringConverter().fromJson(json['exchange_rate']),
      logoShape: const IntOrStringConverter().fromJson(json['logo_shape']),
      showMoreThanOnePrice: const IntOrStringConverter()
          .fromJson(json['show_more_than_one_price']),
      favLang: const IntOrStringConverter().fromJson(json['fav_lang']),
      fontSizeWelcome:
          const IntOrStringConverter().fromJson(json['font_size_welcome']),
      fontTypeWelcome:
          const IntOrStringConverter().fromJson(json['font_type_welcome']),
      fontSizeCategory:
          const IntOrStringConverter().fromJson(json['font_size_category']),
      fontTypeCategoryEn:
          const IntOrStringConverter().fromJson(json['font_type_category_en']),
      fontTypeCategoryAr:
          const IntOrStringConverter().fromJson(json['font_type_category_ar']),
      fontSizeItem:
          const IntOrStringConverter().fromJson(json['font_size_item']),
      fontTypeItemEn:
          const IntOrStringConverter().fromJson(json['font_type_item_en']),
      fontTypeItemAr:
          const IntOrStringConverter().fromJson(json['font_type_item_ar']),
      fontBoldCategory:
          const IntOrStringConverter().fromJson(json['font_bold_category']),
      fontBoldItem:
          const IntOrStringConverter().fromJson(json['font_bold_item']),
      homeOpacity: const IntOrStringConverter().fromJson(json['home_opacity']),
      priceKm: const DoubleOrStringConverter().fromJson(json['price_km']),
      priceType: json['price_type'] as String?,
      shareItemWhatsapp: json['share_item_whatsapp'] as String?,
      adminId: (json['admin_id'] as num?)?.toInt(),
      translations: json['translations'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$RestaurantModelToJson(RestaurantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'note': instance.note,
      'name_en': instance.nameEn,
      'name_ar': instance.nameAr,
      'note_en': instance.noteEn,
      'note_ar': instance.noteAr,
      'name_url': instance.nameUrl,
      'facebook_url': instance.facebookUrl,
      'instagram_url': instance.instagramUrl,
      'whatsapp_phone': instance.whatsappPhone,
      'end_date': const DateYMDConverter().toJson(instance.endDate),
      'message_bad': instance.messageBad,
      'message_good': instance.messageGood,
      'message_perfect': instance.messagePerfect,
      'welcome': instance.welcome,
      'question': instance.question,
      'if_answer_no': instance.ifAnswerNo,
      'birthday_message': instance.birthdayMessage,
      'message_in_home_page': instance.messageInHomePage,
      'cover': instance.cover,
      'logo': instance.logo,
      'logo_home_page': instance.logoHomePage,
      'background_image_home_page': instance.backgroundImageHomePage,
      'background_image_category': instance.backgroundImageCategory,
      'background_image_sub': instance.backgroundImageSub,
      'background_image_item': instance.backgroundImageItem,
      'empty_image': instance.emptyImage,
      'color': const ColorConverter().toJson(instance.color),
      'background_color':
          const ColorConverter().toJson(instance.backgroundColor),
      'f_color_category':
          const ColorConverter().toJson(instance.fColorCategory),
      'f_color_sub': const ColorConverter().toJson(instance.fColorSub),
      'f_color_item': const ColorConverter().toJson(instance.fColorItem),
      'f_color_rating': const ColorConverter().toJson(instance.fColorRating),
      'font_id_en': instance.fontIdEn,
      'font_id_ar': instance.fontIdAr,
      'consumer_spending': instance.consumerSpending,
      'local_administration': instance.localAdmin,
      'reconstruction': instance.reconstruction,
      'is_advertisement':
          const BoolNumConverter().toJson(instance.isAdvertisement),
      'is_news': const BoolNumConverter().toJson(instance.isNews),
      'is_rate': const BoolNumConverter().toJson(instance.isRate),
      'rate_format': instance.rateFormat,
      'is_active': const BoolNumConverter().toJson(instance.isActive),
      'is_table': const BoolNumConverter().toJson(instance.isTable),
      'visited': instance.visited,
      'is_order': const BoolNumConverter().toJson(instance.isOrder),
      'is_taxes': const BoolNumConverter().toJson(instance.isTaxes),
      'city_id': instance.cityId,
      'emoji_id': instance.emojiId,
      'menu_template_id': instance.menuTemplateId,
      'super_admin_id': instance.superAdminId,
      'is_welcome_massege':
          const BoolNumConverter().toJson(instance.isWelcomeMassege),
      'latitude': const DoubleOrStringConverter().toJson(instance.latitude),
      'longitude': const DoubleOrStringConverter().toJson(instance.longitude),
      'is_sub_move': const BoolNumConverter().toJson(instance.isSubMove),
      'is_delivery': const BoolNumConverter().toJson(instance.isDelivery),
      'is_takeout': const BoolNumConverter().toJson(instance.isTakeout),
      'image_or_color': instance.imageOrColor,
      'qr_offline': instance.qrOffline,
      'qr_takeout': instance.qrTakeout,
      'rate_opacity': const IntOrStringConverter().toJson(instance.rateOpacity),
      'sub_opacity':
          const DoubleOrStringConverter().toJson(instance.subOpacity),
      'image_or_write': instance.imageOrWrite,
      'exchange_rate':
          const DoubleOrStringConverter().toJson(instance.exchangeRate),
      'logo_shape': const IntOrStringConverter().toJson(instance.logoShape),
      'show_more_than_one_price':
          const IntOrStringConverter().toJson(instance.showMoreThanOnePrice),
      'fav_lang': const IntOrStringConverter().toJson(instance.favLang),
      'font': instance.font,
      'font_size_welcome':
          const IntOrStringConverter().toJson(instance.fontSizeWelcome),
      'font_type_welcome':
          const IntOrStringConverter().toJson(instance.fontTypeWelcome),
      'font_size_category':
          const IntOrStringConverter().toJson(instance.fontSizeCategory),
      'font_type_category_en':
          const IntOrStringConverter().toJson(instance.fontTypeCategoryEn),
      'font_type_category_ar':
          const IntOrStringConverter().toJson(instance.fontTypeCategoryAr),
      'font_size_item':
          const IntOrStringConverter().toJson(instance.fontSizeItem),
      'font_type_item_en':
          const IntOrStringConverter().toJson(instance.fontTypeItemEn),
      'font_type_item_ar':
          const IntOrStringConverter().toJson(instance.fontTypeItemAr),
      'font_bold_category':
          const IntOrStringConverter().toJson(instance.fontBoldCategory),
      'font_bold_item':
          const IntOrStringConverter().toJson(instance.fontBoldItem),
      'home_opacity': const IntOrStringConverter().toJson(instance.homeOpacity),
      'price_km': const DoubleOrStringConverter().toJson(instance.priceKm),
      'price_type': instance.priceType,
      'share_item_whatsapp': instance.shareItemWhatsapp,
      'admin_id': instance.adminId,
      'translations': instance.translations,
    };
