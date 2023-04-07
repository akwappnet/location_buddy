// ignore_for_file: unused_field, prefer_final_fields, must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:location_buddy/localization/app_localization.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/view/home_view.dart';
import 'package:location_buddy/view/profile_view.dart';
import 'package:location_buddy/view/save_location_view.dart';
import 'package:location_buddy/widgets/custom_dialog_box.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

enum Availability { loading, available, unavailable }

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  final List<Widget> _pages = [
    HomeView(),
    const SaveLocationView(),
    const ProfileView()
  ];

  Availability _availability = Availability.loading;
  bool? isAvailable;
  final InAppReview _inAppReview = InAppReview.instance;
  @override
  void initState() {
    super.initState();

    (<T>(T? o) => o!)(WidgetsBinding.instance).addPostFrameCallback((_) async {
      try {
        isAvailable = await _inAppReview.isAvailable();
        print("----->$isAvailable");

        setState(() {
          // This plugin cannot be tested on Android by installing your app
          // locally. See https://github.com/britannio/in_app_review#testing for
          // more information.
          _availability = isAvailable! && !Platform.isAndroid
              ? Availability.available
              : Availability.unavailable;
        });
      } catch (_) {
        setState(() => _availability = Availability.unavailable);
      }
    });
  }

  Future<void> _requestReview() async {
    _inAppReview.requestReview();
  }

  Future<void> _openStoreListing() async {
    _inAppReview.openStoreListing();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                heading: AppLocalization.of(context)!.translate('exit-app'),
                icon: const Icon(Icons.exit_to_app),
                backgroundColor: CustomColor.primaryColor,
                title: AppLocalization.of(context)!.translate('dialog-title'),
                descriptions: "", //
                btn1Text: AppLocalization.of(context)!.translate('btn-exit'),
                btn2Text: AppLocalization.of(context)!.translate('btn-cancel'),
                onClicked: () {
                  try {
                    _requestReview();
                  } catch (e) {
                    log(e.toString());
                  }
                  /* if (isAvailable == false) {
                    log("-if${isAvailable.toString()}");
                    _openStoreListing();
                    // Navigator.pop(context);
                  } else if (isAvailable == true) {
                    log("-else  if ${isAvailable.toString()}");
                    _requestReview();
                    // Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    log("-else${isAvailable.toString()}");
                    return;
                  } */

                  log(_availability.name); //SystemNavigator.pop();
                  //_showRatingPrompt();
                },
              );
            });
        return Future.value(true);
      },
      child: Scaffold(
          bottomNavigationBar: ValueListenableBuilder(
              valueListenable: _currentIndex,
              builder: (context, value, child) {
                return SalomonBottomBar(
                  currentIndex: _currentIndex.value,
                  onTap: (i) => _currentIndex.value = i,
                  items: [
                    /// Home
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.home),
                      title: Text(
                        AppLocalization.of(context)!.translate('home'),
                      ),
                      selectedColor: CustomColor.primaryColor,
                    ),

                    SalomonBottomBarItem(
                      icon: const Icon(Icons.add),
                      title: Text(
                        AppLocalization.of(context)!.translate('save-route'),
                      ),
                      selectedColor: CustomColor.primaryColor,
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(Icons.person),
                      title: Text(
                        AppLocalization.of(context)!.translate('profile'),
                      ),
                      selectedColor: CustomColor.primaryColor,
                    ),
                  ],
                );
              }),
          body: ValueListenableBuilder(
              valueListenable: _currentIndex,
              builder: (context, value, child) {
                return _pages[_currentIndex.value];
              })),
    );
  }
}
