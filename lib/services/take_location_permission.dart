// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../provider/save_location_view_provider.dart';
import '../utils/colors/colors.dart';
import '../widgets/custom_dialog_box.dart';
import '../widgets/location_disclosure_dialog.dart';

Future<void> locationPermission(BuildContext context) async {
  PermissionStatus permission = await Permission.location.status;
  if (permission == PermissionStatus.denied ||
      permission == PermissionStatus.denied) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return LocationDisclosureDialog(
            heading: "Location Permission Request",

            backgroundColor: CustomColor.primaryColor,
            descriptions:
                "Please Allow Location Buddy to collects location data to show walk ,run and bike rides on map when app is in use.", //
            btn1Text: "Accept",
            btn2Text: "Cancel",
            onClicked: () {
              Navigator.of(context, rootNavigator: true).pop();
              requestLocationPermission(context);
            },
          );
        });
  }
}

Future<void> requestLocationPermission(BuildContext context) async {
  // Provider.of<SaveLocationViewProvider>(context, listen: false)
  //     .getCurrentLocation(context);
  // If location services are already enabled, check for location permissions
  // Request location permission
  var status = await Permission.location.request();
  // Check if permission is granted
  if (status.isGranted) {
    // If "always" permission is already granted, return
    if (await Permission.locationAlways.isGranted) {
      return;
    }
  } else {
    // If permission is not granted, show a pop-up message with option to open settings
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            heading: "Use Your Location",
            icon: const Icon(Icons.info),
            backgroundColor: CustomColor.primaryColor,
            title: "Location Permission Required",
            descriptions:
                "Please allow the app to access your location to enable show walk,run and bike rides on map when app is in use", //
            btn1Text: "Setting",
            btn2Text: "Cancel",
            onClicked: () {
              Navigator.of(context, rootNavigator: true).pop();
              openAppSettings();
            },
          );
        });
  }
}
