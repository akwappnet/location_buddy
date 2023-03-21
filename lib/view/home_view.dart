// ignore_for_file: sized_box_for_whitespace, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_const_constructors_in_immutables, prefer_final_fields

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/utils/assets/assets_utils.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:location_buddy/widgets/custom_dialog_box.dart';
import 'package:lottie/lottie.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  var length = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                width: double.maxFinite,
                height: 350.h,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  CustomColor.lightViolet,
                  CustomColor.Violet,
                  CustomColor.violetSecond,
                ])),
              ),
            ),
            Positioned(
                left: 20.h,
                top: 50.h,
                child: Row(
                  children: [
                    AvatarGlow(
                      endRadius: 30,
                      glowColor: Colors.red,
                      duration: const Duration(seconds: 5),
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 35.h,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'LocationBuddy',
                      style: TextStyle(color: Colors.white, fontSize: 25.sp),
                    ),
                    SizedBox(
                      width: 100.w,
                    ),
                    Icon(
                      Icons.language,
                      color: Colors.white,
                      size: 35.h,
                    )
                  ],
                )),
            Positioned(
              top: 150.h,
              child: Container(
                padding: EdgeInsets.only(left: 20.sp, right: 20.sp, top: 10.sp),
                width: MediaQuery.of(context).size.width,
                height: 780.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.sp),
                        topRight: Radius.circular(30.sp))),
                child: ListView.builder(
                    itemCount: length,
                    itemBuilder: (context, index) {
                      return length == 0
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 50.h,
                                ),
                                Lottie.asset(AssetsUtils.noRoute,
                                    height: 250.h, width: 250.w, animate: true),
                              ],
                            )
                          : Card(
                              elevation: 4,
                              child: ExpansionTile(
                                  leading: Image.asset(
                                    AssetsUtils.route,
                                    height: 30,
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, RoutesName.routeView);
                                    },
                                    child: Image.asset(
                                      AssetsUtils.map,
                                      height: 40.h,
                                    ),
                                  ),
                                  textColor: CustomColor.lightViolet,
                                  iconColor: CustomColor.lightViolet,
                                  initiallyExpanded: false,
                                  maintainState: true,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  title: const Text('HOME TO OFFICE'),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.sp, vertical: 10.sp),
                                      child: ListTileTheme(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                    backgroundColor:
                                                        CustomColor.white,
                                                    child: Image.asset(
                                                        AssetsUtils.source)),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text('Source'),
                                                    const Text(
                                                        'Sola iSquare Building Wappnet System 410')
                                                  ],
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(20.0.sp),
                                              child: Container(
                                                height: 20.h,
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
                                              children: [
                                                CircleAvatar(
                                                    backgroundColor:
                                                        CustomColor.white,
                                                    child: Image.asset(
                                                        AssetsUtils
                                                            .destination)),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text('Destination'),
                                                    const Text(
                                                        'Sola Bridge Gopal Surya Tenament')
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                            );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
