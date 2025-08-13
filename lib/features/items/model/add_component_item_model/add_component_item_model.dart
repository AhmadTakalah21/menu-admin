import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

enum IsBasicComponent { yes, no }

@immutable
class AddComponentItemModel {
  const AddComponentItemModel({
    this.nameAr,
    this.nameEn,
    this.itemId,
    this.isBasicComponent = IsBasicComponent.no,
  });

  final String? nameEn;
  final String? nameAr;
  final int? itemId;
  final IsBasicComponent isBasicComponent;

  AddComponentItemModel copyWith({
    String? nameEn,
    String? nameAr,
    int? itemId,
    IsBasicComponent? isBasicComponent,
  }) {
    return AddComponentItemModel(
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      itemId: itemId ?? this.itemId,
      isBasicComponent: isBasicComponent ?? this.isBasicComponent,
    );
  }

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