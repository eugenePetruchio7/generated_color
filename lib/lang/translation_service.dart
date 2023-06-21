import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'en_us.dart';

class TranslationService extends Translations {
  static const Locale locale = Locale('en', 'US');
  static const Locale fallbackLocale = Locale('en', 'US');

  static const List<String> languageCodes = ['en'];

  static Map<String, Locale> get availableLanguages => {
    'en_language': const Locale('en', 'US'),
  };

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
  };
}
