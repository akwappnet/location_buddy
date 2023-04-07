import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/utils/assets/assets_utils.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/font/font_family.dart';
import 'package:provider/provider.dart';

import '../localization/app_localization.dart';
import '../provider/splash_view_provider.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<SplashViewProvider>(context, listen: false);
    provider.getLanguage(context);
    Timer(const Duration(seconds: 3), () async {
      provider.checkIfUserIsLoggedIn(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                        text:
                            AppLocalization.of(context)!.translate('location'),
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
      ),
    );
  }
}
