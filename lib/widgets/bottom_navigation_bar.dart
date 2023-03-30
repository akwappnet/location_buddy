// ignore_for_file: unused_field, prefer_final_fields, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_buddy/localization/app_localization.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/view/home_view.dart';
import 'package:location_buddy/view/profile_view.dart';
import 'package:location_buddy/view/save_location_view.dart';
import 'package:location_buddy/widgets/custom_dialog_box.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});
  ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  final List<Widget> _pages = [
    HomeView(),
    const SaveLocationView(),
    const ProfileView()
  ];

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
                  SystemNavigator.pop();
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
