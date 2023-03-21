import 'package:flutter/material.dart';
import 'package:location_buddy/provider/splash_view_provider.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RemoteConfigProvider>(
      builder: (context, remoteConfig, _) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(remoteConfig.splashLogoUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text(
                remoteConfig.splashText,
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
