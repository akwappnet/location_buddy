// ignore_for_file: unused_element

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class SplashViewProvider extends ChangeNotifier {
  static FirebaseRemoteConfig? _remoteConfig;

  String _splashLogo =
      'https://cdn-icons-png.flaticon.com/512/2699/2699684.png';
  String _splashText = 'Location Buddy';
  String backgroundColor = "0xFFCE87FB";
  String splashTextColor = "0xFFCE87FB";
  //String _backgroundColor =

  String get splashText => _splashText;
  String get splashLogo => _splashLogo;
  String get _backgroundColor => backgroundColor;
  String get _splashTextColor => splashTextColor;

  void getSpalshText(String value) {
    _splashText = value;
    notifyListeners();
  }

  void getSpalshLogo(String value) {
    _splashLogo = value;
    notifyListeners();
  }

  void getSpalshBackgroundColor(String value) {
    backgroundColor = value;
    notifyListeners();
  }

  void getSpalshTextColor(String value) {
    splashTextColor = value;
    notifyListeners();
  }

//initialize remote config and set default value
  initializeRemoteConfig() async {
    if (_remoteConfig == null) {
      _remoteConfig = FirebaseRemoteConfig.instance;
      final Map<String, dynamic> defaults = <String, dynamic>{
        'splash_logo': _splashLogo,
        'splash_text': _splashText,
        'splash_background_color': backgroundColor,
        'splash_text_color': splashTextColor,
      };
      await _remoteConfig?.setDefaults(defaults);

      _remoteConfig?.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 1),
        minimumFetchInterval: const Duration(seconds: 1),
      ));

      await fetchRemoteConfig();
    }
  }

//fetch Remote Config data
  Future<void> fetchRemoteConfig() async {
    try {
      await _remoteConfig?.fetch();
      await _remoteConfig?.fetchAndActivate();
      if (kDebugMode) {
        print("logo : ${_remoteConfig!.getString('splash_text')}");
        print('Last fetch status: ${_remoteConfig!.lastFetchStatus}');
        print('Last fetch time: ${_remoteConfig!.lastFetchTime}');
        print(
            'splash_background_color: ${_remoteConfig!.getString('splash_background_color')}');
        print(
            'splash_text_color: ${_remoteConfig!.getString('splash_text_color')}');
      }
      getSpalshText(_remoteConfig?.getString('splash_text') ?? _splashText);
      getSpalshLogo(_remoteConfig?.getString('splash_logo') ?? _splashLogo);
      getSpalshBackgroundColor(
          _remoteConfig?.getString('splash_background_color') ??
              backgroundColor);
      getSpalshTextColor(
          _remoteConfig?.getString('splash_text_color') ?? splashTextColor);
    } catch (e) {
      if (kDebugMode) {
        print('Error: ${e.toString()}');
      }
    }
  }
}
