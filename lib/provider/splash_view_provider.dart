import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class SplashViewProvider extends ChangeNotifier {
  static FirebaseRemoteConfig? _remoteConfig;

  String _splashLogo =
      'https://cdn-icons-png.flaticon.com/512/2699/2699684.png';
  String _splashText = 'Location Buddy';
  //String _backgroundColor =

  String get splashText => _splashText;
  String get splashLogo => _splashLogo;

  void getSpalshText(String value) {
    _splashText = value;
    notifyListeners();
  }

  void getSpalshLogo(String value) {
    _splashLogo = value;
    notifyListeners();
  }

//initialize remote config and set default value
  initializeRemoteConfig() async {
    if (_remoteConfig == null) {
      _remoteConfig = await FirebaseRemoteConfig.instance;
      final Map<String, dynamic> defaults = <String, dynamic>{
        'splash_logo':
            'https://cdn-icons-png.flaticon.com/512/2699/2699684.png',
        'splash_text': 'Location Buddy',
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
      }
      getSpalshText(_remoteConfig?.getString('splash_text') ?? _splashText);
      getSpalshLogo(_remoteConfig?.getString('splash_logo') ?? _splashLogo);
      //  _splashLogo = _splashText = _remoteConfig!.getString('splash_text');
    } catch (e) {
      if (kDebugMode) {
        print('Error: ${e.toString()}');
      }
    }
  }
}
