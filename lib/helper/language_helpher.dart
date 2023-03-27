// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class LanguageHelper {
  convertLangNameToLocale(String langNameToConvert) {
    Locale convertedLocale;

    switch (langNameToConvert) {
      case 'English':
        convertedLocale = Locale('en', 'EN');
        break;
      case 'Arabic':
        convertedLocale = Locale('ar', 'AR');
        break;
      case 'Español':
        convertedLocale = Locale('es', 'ES');
        break;
      case 'Русский':
        convertedLocale = Locale('ru', 'RU');
        break;
      default:
        convertedLocale = Locale('en', 'EN');
    }

    return convertedLocale;
  }

  convertLocaleToLangName(String localeToConvert) {
    String langName;

    switch (localeToConvert) {
      case 'en':
        langName = "English";
        break;
      case 'ar':
        langName = "Arabic";
        break;
      case 'es':
        langName = "Español";
        break;
      case 'ru':
        langName = "Русский";
        break;
      default:
        langName = "English";
    }

    return langName;
  }
}
