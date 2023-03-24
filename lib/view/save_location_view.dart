// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/utils/assets/assets_utils.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/widgets/custom_button_widget.dart';
import 'package:location_buddy/widgets/custom_text_field.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';

import '../provider/save_location_view_provider.dart';

class SaveLocationView extends StatefulWidget {
  const SaveLocationView({super.key});

  @override
  State<SaveLocationView> createState() => _SaveLocationViewState();
}

class _SaveLocationViewState extends State<SaveLocationView> {
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
                                  controller: saveLocationViewProvider
                                      .savePointSourceController,
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
                                  controller: saveLocationViewProvider
                                      .savePointDestinationController,
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
                                        readOnly: true,
                                        controller: saveLocationViewProvider
                                            .sourceController,
                                        isObserve: false,
                                        txtHint: 'Source location',
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
                                        controller: saveLocationViewProvider
                                            .destinationController,
                                        txtHint: 'Destination location',
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
                          saveLocationViewProvider.isSaving
                              ? AppButton(
                                  height: 50.sp,
                                  sizes: 20.sp,
                                  text: 'Please wait...',
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    await saveLocationViewProvider
                                        .saveLocationToCollection(
                                            saveLocationViewProvider
                                                .savePointSourceController.text,
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
                                    height: 50.sp,
                                    sizes: 20.sp,
                                    text: 'SAVE ROUTE',
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
}
