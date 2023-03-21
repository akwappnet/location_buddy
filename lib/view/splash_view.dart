import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/splash_view_provider.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

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
                style: const TextStyle(
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
