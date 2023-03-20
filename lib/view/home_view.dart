// ignore_for_file: sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/utils/colors/colors.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
                color: CustomHomeViewColor.lightViolet,
              ),
            ),
            Positioned(
                left: 20.h,
                top: 50.h,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.location_on_outlined,
                        size: 35.h,
                      ),
                      color: Colors.white,
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
                padding: EdgeInsets.only(left: 20.sp, right: 20.sp, top: 30.sp),
                width: MediaQuery.of(context).size.width,
                height: 830.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.sp),
                        topRight: Radius.circular(30.sp))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: ListTileTheme(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  child: Icon(
                                    Icons.circle,
                                    size: 20.h,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Source'),
                                    const Text(
                                        'Sola iSquare Building Wappnet System 410')
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  child: Icon(
                                    Icons.location_on,
                                    size: 30.h,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
