// ignore_for_file: sized_box_for_whitespace, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:location_buddy/localization/app_localization.dart';
import 'package:location_buddy/utils/assets/assets_utils.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/widgets/custom_button_widget.dart';
import 'package:location_buddy/widgets/custom_text_field.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';

import '../provider/save_location_view_provider.dart';
import '../services/location_service_repository.dart';
import '../utils/font/font_family.dart';

class SaveLocationView extends StatefulWidget {
  const SaveLocationView({super.key});

  @override
  State<SaveLocationView> createState() => _SaveLocationViewState();
}

class _SaveLocationViewState extends State<SaveLocationView> {
  ReceivePort port = ReceivePort();
  @override
  void initState() {
    super.initState();
    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }
    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);
    port.listen(
      (dynamic data) {
        // Provider.of<SaveLocationViewProvider>(context, listen: false)
        //     .updateUI(data);
      },
    );
    Provider.of<SaveLocationViewProvider>(context, listen: false)
        .initPlatformState();
    Provider.of<SaveLocationViewProvider>(context, listen: false)
        .onStart(context);
  }

  /*  @override
  void dispose() {
    final saveLocationViewProvider =
        Provider.of<SaveLocationViewProvider>(context, listen: false);
    saveLocationViewProvider.savePointDestinationController.clear();
    saveLocationViewProvider.destinationController.clear();
    saveLocationViewProvider.sourceController.clear();
    super.dispose();
  } */

  @override
  Widget build(BuildContext context) {
    return Consumer<SaveLocationViewProvider>(
        builder: (context, saveLocationViewProvider, _) {
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
                    child: Lottie.asset(AssetsUtils.saveLocation,
                        fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 150.h,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 30.sp, right: 20.sp, top: 20.sp),
                      width: MediaQuery.of(context).size.width,
                      height: 780.h,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.sp),
                              topRight: Radius.circular(30.sp))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalization.of(context)!.translate('heading'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CustomColor.primaryColor,
                              fontSize: 22.sp,
                              fontFamily: FontFamliyM.ROBOTOBOLD,
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 15.sp),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.3,
                                  child: BuildTextFormField(
                                    controller: saveLocationViewProvider
                                        .savePointDestinationController,
                                    isObserve: false,
                                    txtHint: AppLocalization.of(context)!
                                        .translate('hint-title'),
                                  ),
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
                                        child: Image.asset(AssetsUtils.source)),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    SizedBox(
                                      width: 250.w,
                                      child: BuildTextFormField(
                                        readOnly: true,
                                        controller: saveLocationViewProvider
                                            .sourceController,
                                        isObserve: false,
                                        txtHint: AppLocalization.of(context)!
                                            .translate('hint-source'),
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
                                            AssetsUtils.destination)),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    SizedBox(
                                      width: 250.w,
                                      child: placesAutoCompleteTextField(
                                          saveLocationViewProvider
                                              .destinationController),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          saveLocationViewProvider.isSaving
                              ? AppButton(
                                  height: 50.sp,
                                  mycolor: CustomColor.primaryColor,
                                  sizes: 20.sp,
                                  text: AppLocalization.of(context)!
                                      .translate('save-button2'),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    await saveLocationViewProvider
                                        .saveLocationToCollection(
                                            saveLocationViewProvider
                                                .savePointDestinationController
                                                .text,
                                            saveLocationViewProvider
                                                .sourceController.text,
                                            saveLocationViewProvider
                                                .destinationController.text,
                                            context);
                                  },
                                  child: AppButton(
                                    mycolor: CustomColor.primaryColor,
                                    height: 50.sp,
                                    sizes: 20.sp,
                                    text: AppLocalization.of(context)!
                                        .translate('save-button'),
                                  ),
                                ),
                          //Expanded(child: ListViewWidget())
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
    });
  }

  placesAutoCompleteTextField(TextEditingController controller) {
    return GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        textStyle: TextStyle(
            color: CustomColor.black,
            fontSize: 16.sp,
            fontFamily: FontFamliyM.ROBOTOREGULAR),
        googleAPIKey: "AIzaSyAERKSFYMxdSR6mrMmgyesmQOr8miAFd4c",
        inputDecoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 15.sp,
          ),
          border: InputBorder.none,
          isDense: false,
          labelText: AppLocalization.of(context)!.translate('hint-destination'),
          errorStyle: const TextStyle(color: Colors.black),
          labelStyle: TextStyle(
              color: CustomColor.black,
              fontSize: 16.sp,
              fontFamily: FontFamliyM.ROBOTOREGULAR),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.sp),
              borderSide: BorderSide(color: Colors.black, width: 1.w)),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.sp),
              borderSide: BorderSide(color: Colors.black, width: 1.w)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.sp),
              borderSide: BorderSide(color: Colors.black, width: 1.w)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.sp),
              borderSide: BorderSide(color: Colors.black, width: 1.w)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.sp),
              borderSide: BorderSide(color: Colors.black, width: 1.w)),
        ),
        debounceTime: 800,
        countries: const ["in", "fr"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          log("Latitude${prediction.lng}");
          Provider.of<SaveLocationViewProvider>(context, listen: false)
              .setDestinationLocationLatitude(prediction.lat.toString());
          Provider.of<SaveLocationViewProvider>(context, listen: false)
              .setDestinationLocationlongitude(prediction.lng.toString());
        },
        itmClick: (Prediction prediction) {
          log("Latitude-->${prediction.description!.toLowerCase()}");
          log("Longitude--->${prediction.lat}");
          controller.text = prediction.description!;

          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description!.length));
        }
        // default 600 ms ,
        );
  }
}
