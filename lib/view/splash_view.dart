import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/utils/assets/assets_utils.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/font/font_family.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/app_localization.dart';
import '../provider/current_data_provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    getLanguage();
    Timer(const Duration(seconds: 3), () async {
      checkIfUserIsLoggedIn();
    });
  }

  Future<void> getLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lan = prefs.getString("dateFormat") ?? "English";
    log(lan);
    // ignore: use_build_context_synchronously
    final provider = Provider.of<CurrentData>(context, listen: false);
    provider.changeLocale(lan);
  }

  Future<void> checkIfUserIsLoggedIn() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      log(auth.currentUser?.displayName ?? "No name");
      Navigator.popAndPushNamed(context, RoutesName.bottomBar);
    } else {
      Navigator.popAndPushNamed(context, RoutesName.siginView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomColor.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 190.h,
              width: 190.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AssetsUtils.splash),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 50.h),
            Center(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 32.sp,
                  ),
                  children: [
                    TextSpan(
                      text: AppLocalization.of(context)!.translate('location'),
                      style: TextStyle(
                          color: CustomColor.primaryColor,
                          fontWeight: FontWeight.w800,
                          fontFamily: FontFamliyM.ROBOTOBLACK),
                    ),
                    TextSpan(
                      text: AppLocalization.of(context)!.translate('buddy'),
                      style: TextStyle(
                          color: CustomColor.secondaryColor,
                          fontWeight: FontWeight.w800,
                          fontFamily: FontFamliyM.ROBOTOBOLD),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
