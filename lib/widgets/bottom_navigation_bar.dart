// ignore_for_file: unused_field, prefer_final_fields, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/view/home_view.dart';
import 'package:location_buddy/view/save_location_view.dart';
import 'package:location_buddy/widgets/custom_dialog_box.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});
  ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  final List<Widget> _pages = [HomeView(), const SaveLocationView()];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                heading: "Exit App",
                icon: const Icon(Icons.exit_to_app),
                backgroundColor: CustomColor.Violet,
                title: "Are you sure you want to exit app ?",
                descriptions: "", //
                btn1Text: "Exit",
                btn2Text: "Cancel",
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
                      title: const Text("Home"),
                      selectedColor: CustomColor.Violet,
                    ),

                    SalomonBottomBarItem(
                      icon: const Icon(Icons.add),
                      title: const Text("Save Route"),
                      selectedColor: Colors.red,
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
