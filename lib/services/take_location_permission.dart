// ignore_for_file: use_build_context_synchronously

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
                "Location Buddy collects location data to show walk , run and bike rides on map even when app is closed or not in use.", //
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
  // If location services are already enabled, check for location permissions
  // Request location permission
  var status = await Permission.location.request();

  // Check if permission is granted
  if (status.isGranted) {
    // If "always" permission is already granted, return
    if (await Permission.locationAlways.isGranted) {
      return;
    }

    // Request "always" permission
    status = await Permission.locationAlways.request();

    // Check if permission is granted
    if (status.isGranted) {
      final saveLocationViewProvider =
          Provider.of<SaveLocationViewProvider>(context, listen: false);
      saveLocationViewProvider.getCurrentLocation(context);

      return;
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: CustomColor.redColor,
        content: Text(
            "Location Buddy collect location data to enable show walk,run and bike rides on map even when app is closed or not in use"),
        duration: Duration(seconds: 3),
      ),
    );
  }

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
              "Please allow the app to access your location all the time enable show walk,run and bike rides on map even when app is closed or not in use", //
          btn1Text: "Setting",
          btn2Text: "Cancel",
          onClicked: () {
            Navigator.of(context, rootNavigator: true).pop();
            openAppSettings();
          },
        );
      });
}
