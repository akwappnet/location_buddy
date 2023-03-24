// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
import 'package:flutter/material.dart';

import 'package:location_buddy/helper/language_helpher.dart';

class CurrentData with ChangeNotifier {
  late String currentLanguage = "";
  late Locale locale = Locale("en", "US");

  LanguageHelper languageHelper = LanguageHelper();

  Locale get getlocale => locale;

  void changeLocale(String newLocale) {
    Locale convertedLocale;

    currentLanguage = newLocale;

    convertedLocale = languageHelper.convertLangNameToLocale(newLocale);
    locale = convertedLocale;
    notifyListeners();
  }

  defineCurrentLanguage(context) {
    String definedCurrentLanguage;

    if (currentLanguage != "")
      definedCurrentLanguage = currentLanguage;
    else {
      print(
          "locale from currentData: ${Localizations.localeOf(context).toString()}");
      definedCurrentLanguage = languageHelper
          .convertLocaleToLangName(Localizations.localeOf(context).toString());
    }

    return definedCurrentLanguage;
  }
}
