// ignore_for_file: unused_field, prefer_final_fields

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class HomeViewProvider extends ChangeNotifier {
  static FirebaseRemoteConfig? _remoteConfig;

  String _appName = 'Location Buddy';

  String get appName => _appName;

  void setAppName(String value) {
    _appName = value;
    notifyListeners();
  }

  //initialize remote config and set default value
  initializeRemoteConfig() async {
    if (_remoteConfig == null) {
      _remoteConfig = FirebaseRemoteConfig.instance;
      final Map<String, dynamic> defaults = <String, dynamic>{
        'app_name': _appName,
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
      setAppName(_remoteConfig?.getString('app_name') ?? _appName);
    } catch (e) {
      if (kDebugMode) {
        print('Error: ${e.toString()}');
      }
    }
  }
}
