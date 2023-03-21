import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigProvider extends ChangeNotifier {
  FirebaseRemoteConfig? _remoteConfig;

  // default values for splash screen logo and text
  String _splashLogoUrl =
      'https://cdn-icons-png.flaticon.com/512/2699/2699684.png';
  String _splashText = 'Welcome to my app!';

  String get splashLogoUrl => _splashLogoUrl;
  String get splashText => _splashText;

  RemoteConfigProvider() {
    _remoteConfig = FirebaseRemoteConfig.instance;

    // set default values
    _remoteConfig?.setDefaults({
      'splash_logo_url': _splashLogoUrl,
      'splash_text': _splashText,
    });

    // fetch new values every 30 minutes
    _remoteConfig?.fetchAndActivate().then((value) {
      if (value) {
        _splashLogoUrl =
            _remoteConfig?.getString('splash_logo_url') ?? _splashLogoUrl;
        _splashText = _remoteConfig?.getString('splash_text') ?? _splashText;
        notifyListeners();
      }
    });
  }
}
