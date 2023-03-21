// ignore_for_file: unused_field, prefer_final_fields, must_be_immutable

import 'package:flutter/material.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/view/home_view.dart';
import 'package:location_buddy/view/save_location_view.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({super.key});
  ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);

  final List<Widget> _pages = [HomeView(), SaveLocationView()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                  /// Likes
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
            }));
  }
}
