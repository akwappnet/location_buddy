// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class AppLocalization {
  AppLocalization(this.locale);

  final Locale locale;

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      //bottom bar language translate
      'profile': 'Profile',
      'save-route': 'Save Route',
      'home': 'Home',
      //home page language translate
      'app-name': 'Location Buddy',
      'source': 'Source',
      'destination': 'Destination',
      'no-record': 'No location information !',
      'no-record2': "When you have loction details you'll see them here..",
      //save route page language translate
      'heading': 'SAVE ROUTE FOR YOUR DESTINATION',
      'hint-title': 'Enter Title eg.Office',
      'hint-source': 'Source location',
      'hint-destination': 'Destination location',
      'save-button': 'SAVE ROUTE',
      'save-button2': 'Please Wait..',
      //profile page language translate
      'welcome': "Welcome",
      'setting': "App Setting",
      'language': 'Language',
      'select-language': 'Select Language',
      'privacy': 'Privacy',
      'privacy-subtitle': 'Location Buddy Privacy',
      'about': 'About',
      'about-title': 'Learn more about location buddy',
      'account': 'Account',
      'logout': 'Logout',
      'logout-title': 'I want to logout from app',
      'delete-account': 'Delete Account',
      'delete-account-title': 'I want to delete account,',
    },
    'ar': {
      //bottom bar language translate
      'profile': 'ملف تعريف',
      'save-route': 'حفظ الطريق',
      'home': 'وطن',
      //home page language translate
      'app-name': 'الموقع الأصدقاء',
      'source': 'مصدر',
      'destination': 'مقصد',
      'no-record': 'لا توجد معلومات الموقع!',
      'no-record2': 'عندما يكون لديك تفاصيل تحديد الموقع ، ستراها هنا ...',
      //save route page language translate
      'heading': 'حفظ الطريق لوجهتك',
      'hint-title': 'أدخل العنوان على سبيل المثال. مكتب',
      'hint-source': 'موقع المصدر',
      'hint-destination': 'موقع المصدر',
      'save-button': 'حفظ المسار',
      'save-button2': 'الرجاء الانتظار..',
      //profile page language translate
      'welcome': " أهلًا وسهلًا",
      'setting': "إعداد التطبيق",
      'language': 'اللغة',
      'select-language': 'اختر اللغة',
      'privacy': 'الخصوصيه',
      'privacy-subtitle': 'خصوصية الأصدقاء الموقع',
      'about': 'عن',
      'about-title': 'تعرف على المزيد حول صديق الموقع',
      'account': 'حساب',
      'logout': 'الخروج',
      'logout-title': 'أريد تسجيل الخروج من التطبيق',
      'delete-account': 'حذف الحساب',
      'delete-account-title': 'أريد حذف الحساب',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]![key] ?? '** $key not found';
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) {
    // Returning a SynchronousFuture here because an async "load" operation
    // isn't needed to produce an instance of DemoLocalizations.
    return SynchronousFuture<AppLocalization>(
      AppLocalization(locale),
    );
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
