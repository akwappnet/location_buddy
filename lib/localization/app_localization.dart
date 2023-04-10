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
      'hint-source': 'Click To Get Current Location',
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
      'logout-desc': 'Are you sure you want to logout ?',
      'logout-title': 'I want to logout from app',
      'delete-account': 'Delete Account',
      'delete-account-title': 'I want to delete account,',
      'rate-us': 'Rate us',
      'rate-us-subtitle': 'i want to give rating',
      //splash page language translate
      'location': 'Location ',
      'buddy': 'Buddy',
      //sign in , sign up ,forgot password page language translate
      'back': 'Back',
      'exit-app': 'Exit App',
      'dialog-title': 'Are you sure you want to exit app ?',
      'btn-cancel': 'Cancel',
      'btn-exit': 'Exit',
      'txt-name-hint': 'Enter Name',
      'txt-email-hint': 'Enter Email',
      'txt-password-hint': 'Enter Password',
      'forgot-password': 'Forgot password ?',
      'forgot-password-1': 'Forgot password',
      'sign-in': 'Sign in',
      'continue': 'Continue',
      'google': 'Google',
      'delete': 'Delete',
      'delete-account-msg': 'Are you sure you want to delete your account ?',
      'dont-account': 'Don’t have an account ? ',
      'already-account': 'Already have an account ? ',
      'sign-up': 'Sign Up',
      'fogot-desc': 'Enter Email to contact you to reset your password',
      'email-sent': 'Password reset email sent!',
      //validation  language translate
      'empty-field': 'All field must be filled',
      'validate-email': 'Please enter valid email',
      'validate-password':
          'Use 8 or more characters with a mix of capital & small letters, \nnumbers & symbols',
      //signin provider language translate
      'success': 'Success',
      'login-successfull': 'Login successful',
      'registration-successfull': 'Registration successful',
      'error': 'Error',
      'ok': 'Ok',
      'error-somthing': 'Somthing went wrong please try again...',
      'error-no-user': 'No user found for that email.',
      'error-password': 'Wrong password...',
      'password-weak': 'The password provided is too weak.',
      'email-already-exists': 'The account already exists for that email.',
      'account-delete-success': 'Your account deleted Successfully',
      'account-delete-error':
          'You need to reauthenticate before deleting your account',
      //save location provider language translate
      'save-successfull': 'Location Saved successful',
      'error-data-delete': 'Error while deleting data',
      'live-tracking': 'Live Tracking',
      'stop-tracking': 'Stop Tracking',
      'delete-data': 'Delete',
      'delete-data-info': 'Are you sure you want to delete',
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
      'delete': 'حذف',
      'delete-account-msg': 'هل انت متأكد انك تريد حذف حسابك ؟',
      'logout-desc': 'هل أنت متأكد أنك تريد تسجيل الخروج ؟',
      'logout-title': 'أريد تسجيل الخروج من التطبيق',
      'delete-account': 'حذف الحساب',
      'delete-account-title': 'أريد حذف الحساب',
      'rate-us': 'قيمنا',
      'rate-us-subtitle': 'أريد أن أعطي معدل',
      //splash page language translate
      'location': 'الأصدقاء ',
      'buddy': 'الموقع',
      //sign in , sign up ,forgot password page language translate
      'back': 'خلف',
      'exit-app': 'الخروج من التطبيق',
      'dialog-title': 'هل أنت متأكد أنك تريد الخروج من التطبيق؟',
      'btn-cancel': 'يلغي',
      'btn-exit': 'مخرج',
      'txt-name-hint': 'أدخل الاسم',
      'txt-email-hint': 'أدخل البريد الإلكتروني',
      'txt-password-hint': 'أدخل كلمة المرور',
      'forgot-password': 'هل نسيت كلمة السر ؟',
      'forgot-password-1': 'هل نسيت كلمة السر',
      'sign-in': 'تسجيل الدخول',
      'continue': 'يكمل',
      'google': 'جوجل',
      'dont-account': 'ليس لديك حساب؟',
      'already-account': 'هل لديك حساب ؟',
      'sign-up': 'اشتراك',
      'fogot-desc':
          'أدخل البريد الإلكتروني للاتصال بك لإعادة تعيين كلمة المرور الخاصة بك',
      'email-sent': 'تم إرسال بريد إلكتروني لإعادة تعيين كلمة المرور!',
      //validation  language translate
      'empty-field': 'يجب ملء هذا الحقل',
      'validate-email': 'الرجاء إدخال بريد إلكتروني صحيح',
      'validate-password':
          'استخدم 8 أحرف أو أكثر مع مزيج من الأحرف الكبيرة والصغيرة ، \nالأرقام والرموز',
      //signin provider language translate
      'success': 'نجاح',
      'login-successfull': 'تسجيل الدخول ناجح',
      'registration-successfull': 'تم التسجيل بنجاح',
      'error': 'خطأ',
      'ok': 'نعم',
      'error-somthing': 'حدث خطأ ما يرجى المحاولة مرة أخرى ...',
      'error-no-user': 'لم يتم العثور على مستخدم لهذا البريد الإلكتروني.',
      'error-password': 'كلمة مرور خاطئة...',
      'password-weak': 'كلمة المرور المقدمة ضعيفة للغاية.',
      'email-already-exists': 'الحساب موجود بالفعل لهذا البريد الإلكتروني.',
      'account-delete-success': 'تم حذف حسابك بنجاح',
      'account-delete-error': 'تحتاج إلى إعادة المصادقة قبل حذف حسابك',
      //save location provider language translate
      'save-successfull': 'تم حفظ الموقع بنجاح',
      'error-data-delete': 'خطأ أثناء حذف البيانات',
      'live-tracking': 'تتبع مباشر',
      'stop-tracking': 'توقف عن التعقب',
      'delete-data': 'يمسح',
      'delete-data-info': 'هل أنت متأكد أنك تريد حذف',
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
