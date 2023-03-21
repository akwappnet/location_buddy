// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/utils/assets/assets_utils.dart';
import 'package:location_buddy/widgets/custom_text_field.dart';
import 'package:lottie/lottie.dart';

class SaveLocationView extends StatelessWidget {
  const SaveLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: 150.h,
                child:
                    Lottie.asset(AssetsUtils.saveLocation, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              top: 150.h,
              child: Container(
                padding: EdgeInsets.only(left: 30.sp, right: 20.sp, top: 20.sp),
                width: MediaQuery.of(context).size.width,
                height: 780.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.sp),
                        topRight: Radius.circular(30.sp))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SAVE ROUTE TO YOUR DESTINATION',
                      style: TextStyle(fontSize: 20.sp),
                    ),
                    SizedBox(
                      width: 150.w,
                      child: BuildTextFormField(
                        isObserve: true,
                        txtHint: 'hello',
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
