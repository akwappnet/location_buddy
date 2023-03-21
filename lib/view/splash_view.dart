import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/provider/splash_view_provider.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:provider/provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    final splashProvider =
        Provider.of<SplashViewProvider>(context, listen: false);
    splashProvider.initializeRemoteConfig();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, RoutesName.bottomBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashViewProvider>(
      builder: (context, remoteConfig, _) {
        Color backgroundColor = Color(
            int.parse(remoteConfig.backgroundColor.substring(2), radix: 16));
        Color textColor = Color(
            int.parse(remoteConfig.splashTextColor.substring(2), radix: 16));
        return Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: backgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 210.h,
                  width: 200.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(remoteConfig.splashLogo),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),

                SizedBox(height: 50.h),
                Center(
                  child: Text(
                    remoteConfig.splashText,
                    style: TextStyle(
                        fontSize: 32.sp,
                        color: textColor,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       remoteConfig.fetchRemoteConfig();
                //     },
                //     child: Text("Reload"))
              ],
            ),
          ),
        );
      },
    );
  }
}
