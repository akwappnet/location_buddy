// ignore_for_file: sized_box_for_whitespace, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_const_constructors_in_immutables, prefer_final_fields

import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:location_buddy/data/default_data.dart';
import 'package:location_buddy/provider/current_data_provider.dart';
import 'package:location_buddy/provider/home_view_provider.dart';
import 'package:location_buddy/provider/live_traking_view_provider.dart';
import 'package:location_buddy/utils/assets/assets_utils.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/font/font_family.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';

import '../provider/save_location_view_provider.dart';
import '../services/take_location_permission.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // var length = 1;
  final DefaultData defaultData = DefaultData();
  @override
  void initState() {
    super.initState();

    final homeProvider = Provider.of<HomeViewProvider>(context, listen: false);

    homeProvider.initializeRemoteConfig();
    log("----------->[4]");
    requestLocationPermission(context);
    log("----------->[5]");
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                        remoteConfig.appName,
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
                      SizedBox(
                        width: 50.w,
                      ),
                      Icon(
                        Icons.language,
                        color: Colors.white,
                        size: 35.h,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                    ],
                  )),
              RefreshIndicator(
                displacement: 30.sp,
                color: CustomColor.Violet,
                onRefresh: () async {
                  log("----");
                },
                child: Positioned(
                  top: 150.h,
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 20.sp, right: 20.sp, top: 10.sp),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.sp),
                            topRight: Radius.circular(30.sp))),
                    child: locationInfoProvider.isLoading
                        ? Lottie.asset(AssetsUtils.loadinghome,
                            height: 250.h, width: 250.w, animate: true)
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
                                    'No location information ! ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 28.sp,
                                        fontFamily: FontFamliyM.SEMIBOLD,
                                        color: CustomColor.Violet,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    "When you have loction details you'll see them here...",
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

                                  return GestureDetector(
                                    onLongPress: () {
                                      locationInfoProvider
                                          .deleteLocationInformation(
                                              locationInfo.id!);
                                      // locationInfoProvider.deletePerson(locationInfo.id!);
                                    },
                                    child: Card(
                                      elevation: 4,
                                      child: ExpansionTile(
                                          leading: Image.asset(
                                            AssetsUtils.route,
                                            height: 30,
                                          ),
                                          trailing: GestureDetector(
                                            onTap: () {
                                              double latitude = double.parse(
                                                  locationInfo
                                                      .destinationLocationLatitude
                                                      .toString());
                                              double longitude = double.parse(
                                                  locationInfo
                                                      .destinationLocationlongitude
                                                      .toString());
                                              Provider.of<LiveTrackingViewProvider>(
                                                      context,
                                                      listen: false)
                                                  .setLocationData(
                                                      latitude, longitude);
                                              Navigator.pushNamed(
                                                context,
                                                RoutesName.livetrakingpage,
                                              );
                                            },
                                            child: Image.asset(
                                              AssetsUtils.map,
                                              height: 40.h,
                                            ),
                                          ),
                                          textColor: CustomColor.lightViolet,
                                          iconColor: CustomColor.lightViolet,
                                          initiallyExpanded: true,
                                          maintainState: true,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          title: Text(
                                            locationInfo.savePointDestination!,
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                fontFamily:
                                                    FontFamliyM.SEMIBOLD,
                                                fontWeight: FontWeight.w600),
                                            softWrap: false,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.sp,
                                                  vertical: 10.sp),
                                              child: ListTileTheme(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .white,
                                                            child: Image.asset(
                                                                AssetsUtils
                                                                    .source)),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              ' Source',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20.sp,
                                                                  fontFamily:
                                                                      FontFamliyM
                                                                          .SEMIBOLD,
                                                                  color:
                                                                      CustomColor
                                                                          .Violet,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  3.5,
                                                              child: Text(
                                                                '${locationInfo.sourceLocation}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      18.sp,
                                                                  fontFamily:
                                                                      FontFamliyM
                                                                          .BOLD,
                                                                ),
                                                                softWrap: false,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.all(
                                                          20.0.sp),
                                                      child: Container(
                                                        height: 20.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          border:
                                                              RDottedLineBorder(
                                                            left:
                                                                const BorderSide(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        CircleAvatar(
                                                            backgroundColor:
                                                                CustomColor
                                                                    .white,
                                                            child: Image.asset(
                                                                AssetsUtils
                                                                    .destination)),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Destination',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20.sp,
                                                                  fontFamily:
                                                                      FontFamliyM
                                                                          .SEMIBOLD,
                                                                  color:
                                                                      CustomColor
                                                                          .Violet,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  3.5,
                                                              child: Text(
                                                                '${locationInfo.destinationLocation}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      18.sp,
                                                                  fontFamily:
                                                                      FontFamliyM
                                                                          .BOLD,
                                                                ),
                                                                softWrap: false,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  );
                                }),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
