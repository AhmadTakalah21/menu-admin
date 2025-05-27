import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

enum IsBasicComponent { yes, no }

@immutable
class AddComponentItemModel {
  const AddComponentItemModel({
    this.nameAr,
    this.nameEn,
    this.isBasicComponent = IsBasicComponent.no, // القيمة الافتراضية
  });

  final String? nameEn;
  final String? nameAr;
  final IsBasicComponent isBasicComponent;

  AddComponentItemModel copyWith({
    String? nameEn,
    String? nameAr,
    IsBasicComponent? isBasicComponent,
  }) {
    return AddComponentItemModel(
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      isBasicComponent: isBasicComponent ?? this.isBasicComponent,
    );
  }

  // يمكنك إضافة دوال مساعدة لتحويل القيم إذا لزم الأمر
  bool get isBasic => isBasicComponent == IsBasicComponent.yes;

  String get isBasicDisplayName {
    switch (isBasicComponent) {
      case IsBasicComponent.yes:
        return "yes".tr();
      case IsBasicComponent.no:
        return "no".tr();
    }
  }
}