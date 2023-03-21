// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/utils/assets/assets_utils.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/widgets/custom_button_widget.dart';
import 'package:location_buddy/widgets/custom_text_field.dart';
import 'package:lottie/lottie.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';

class SaveLocationView extends StatelessWidget {
  const SaveLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                child: Center(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 30.sp, right: 20.sp, top: 20.sp),
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
                          'SAVE ROUTE FOR YOUR DESTINATION',
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 160.w,
                              child: BuildTextFormField(
                                isObserve: false,
                                txtHint: 'eg.office',
                              ),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text('To', style: TextStyle(fontSize: 20.sp)),
                            SizedBox(
                              width: 5.w,
                            ),
                            SizedBox(
                              width: 160.w,
                              child: BuildTextFormField(
                                isObserve: false,
                                txtHint: 'eg.market',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CircleAvatar(
                                      backgroundColor: CustomColor.white,
                                      child:
                                          Image.asset(AssetsUtils.sourceRed)),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  SizedBox(
                                    width: 250.w,
                                    child: BuildTextFormField(
                                      isObserve: false,
                                      txtHint: 'Source',
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(20.0.sp),
                                child: Container(
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    border: RDottedLineBorder(
                                      left: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CircleAvatar(
                                      backgroundColor: CustomColor.white,
                                      child: Image.asset(
                                          AssetsUtils.destinationRed)),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  SizedBox(
                                    width: 250.w,
                                    child: BuildTextFormField(
                                      isObserve: false,
                                      txtHint: 'Destination',
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        AppButton(
                          height: 50.sp,
                          sizes: 20.sp,
                          text: 'SAVE ROUTE',
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
