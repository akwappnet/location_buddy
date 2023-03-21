/* import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService({required FirebaseRemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  Future<void> initialize() async {
    try {
      await _remoteConfig.setDefaults(<String, dynamic>{
        'splash_logo':
            'https://cdn-icons-png.flaticon.com/512/2699/2699684.png',
        'splash_text': 'Location Buddy',
      });
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 1),
      ));
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      print('Error initializing remote config: $e');
    }
  }

  String getSplashLogo() {
    return _remoteConfig.getString('splash_logo');
  }

  String getSplashText() {
    return _remoteConfig.getString('splash_text');
  }
}
 */