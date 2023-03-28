// ignore_for_file: sized_box_for_whitespace, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_const_constructors_in_immutables, prefer_final_fields

import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:location_buddy/localization/app_localization.dart';
import 'package:location_buddy/provider/home_view_provider.dart';
import 'package:location_buddy/provider/live_traking_view_provider.dart';
import 'package:location_buddy/utils/assets/assets_utils.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/font/font_family.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../provider/save_location_view_provider.dart';
import '../services/take_location_permission.dart';
import '../widgets/custom_dialog_box.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // var length = 1;

  @override
  void initState() {
    super.initState();

    requestLocationPermission(context);

    Provider.of<SaveLocationViewProvider>(context, listen: false)
        .fetchLocationInformation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationInfoProvider = Provider.of<SaveLocationViewProvider>(context);

    return Consumer<HomeViewProvider>(builder: (context, remoteConfig, _) {
      return Scaffold(
        backgroundColor: CustomColor.primaryColor,
        body: Column(
          children: [
            SizedBox(
              height: 50.h,
            ),
            Row(
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
                  AppLocalization.of(context)!.translate('app-name'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.sp,
                    fontFamily: FontFamliyM.SEMIBOLD,
                  ),
                ),
                // Text(
                //   AppLocalization.of(context)!.translate('hello-world'),
                //   style: TextStyle(color: Colors.indigo, fontSize: 5),
                // ),
              ],
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: CustomColor.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.sp),
                        topRight: Radius.circular(30.sp))),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 20.sp, right: 20.sp, top: 10.sp),
                    width: MediaQuery.of(context).size.width,
                    child: locationInfoProvider.isLoading
                        ? Column(
                            children: [
                              SizedBox(
                                height: 250.h,
                              ),
                              Center(
                                child: Lottie.asset(AssetsUtils.loadinghome,
                                    height: 250.h, width: 250.w, animate: true),
                              ),
                            ],
                          )
                        : locationInfoProvider.locationInfo.isEmpty
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: 60.h,
                                  ),
                                  Lottie.asset(AssetsUtils.noRoute,
                                      height: 250.h,
                                      width: 250.w,
                                      animate: true),
                                  SizedBox(
                                    height: 50.h,
                                  ),
                                  Text(
                                    AppLocalization.of(context)!
                                        .translate('no-record'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 28.sp,
                                        fontFamily: FontFamliyM.SEMIBOLD,
                                        color: CustomColor.primaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    AppLocalization.of(context)!
                                        .translate('no-record2'),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontFamily: FontFamliyM.SEMIBOLD,
                                        color: CustomColor.black,
                                        fontWeight: FontWeight.w200),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    locationInfoProvider.locationInfo.length,
                                itemBuilder: (context, index) {
                                  final locationInfo =
                                      locationInfoProvider.locationInfo[index];

                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: const BorderSide(
                                          color: Colors.black12, width: 1.0),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      height: 195.h,
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25.sp, vertical: 10.sp),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  locationInfo
                                                      .savePointDestination!,
                                                  style: TextStyle(
                                                      color: CustomColor
                                                          .primaryColor,
                                                      fontSize: 20.sp,
                                                      fontFamily:
                                                          FontFamliyM.SEMIBOLD,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                  softWrap: false,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      double latitude = double
                                                          .parse(locationInfo
                                                              .destinationLocationLatitude
                                                              .toString());
                                                      double longitude = double
                                                          .parse(locationInfo
                                                              .destinationLocationlongitude
                                                              .toString());
                                                      Provider.of<LiveTrackingViewProvider>(
                                                              context,
                                                              listen: false)
                                                          .setLocationData(
                                                              latitude,
                                                              longitude);
                                                      Navigator.pushNamed(
                                                        context,
                                                        RoutesName
                                                            .livetrakingpage,
                                                      );
                                                    },
                                                    child: Image.asset(
                                                      AssetsUtils.mapNew,
                                                      height: 32.h,
                                                      width: 40.w,
                                                    ))
                                              ],
                                            ),
                                            Text(
                                              AppLocalization.of(context)!
                                                  .translate('source'),
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontFamily:
                                                      FontFamliyM.SEMIBOLD,
                                                  color: CustomColor
                                                      .secondaryColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3,
                                              child: Text(
                                                '${locationInfo.sourceLocation}',
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontFamily: FontFamliyM.BOLD,
                                                ),
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            Text(
                                              AppLocalization.of(context)!
                                                  .translate('destination'),
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontFamily:
                                                      FontFamliyM.SEMIBOLD,
                                                  color: CustomColor
                                                      .secondaryColor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      3.5,
                                                  child: Text(
                                                    '${locationInfo.destinationLocation}',
                                                    style: TextStyle(
                                                      fontSize: 18.sp,
                                                      fontFamily:
                                                          FontFamliyM.BOLD,
                                                    ),
                                                    softWrap: false,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return CustomDialogBox(
                                                                backgroundColor:
                                                                    CustomColor
                                                                        .primaryColor,
                                                                heading:
                                                                    "Delete",
                                                                title:
                                                                    "Are you sure you want to delete ?",
                                                                descriptions:
                                                                    "",
                                                                btn1Text:
                                                                    "Delete",
                                                                icon: const Icon(
                                                                    Icons
                                                                        .delete_outline),
                                                                btn2Text:
                                                                    "Cancel",
                                                                onClicked: () {
                                                                  locationInfoProvider.deleteLocationInformation(
                                                                      locationInfo
                                                                          .id!,
                                                                      context);
                                                                });
                                                          });
                                                    },
                                                    child: Image.asset(
                                                      AssetsUtils.delete,
                                                      height: 30.h,
                                                      width: 40.w,
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
