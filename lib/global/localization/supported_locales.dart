import 'package:flutter/material.dart';

abstract class SupportedLocales {
  static const english = Locale('en');
  static const arabic = Locale('ar');

  static final List<Locale> locales = [
    const Locale('en'),
    const Locale('ar'),
  ];

  static final List<LanguageModel> languages = [
    const LanguageModel(english,"EN"),
    const LanguageModel(arabic,"AR"),
  ];

  static const String path = 'assets/locales';
}

class LanguageModel {
  const LanguageModel(this.locale, this.code);

  final Locale locale;
  final String code;
}
