// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../provider/save_location_view_provider.dart';
import '../utils/colors/colors.dart';

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
        content:
            Text("Please allow the app to access your location all the time"),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // If permission is not granted, show a pop-up message with option to open settings
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Location Permission Required'),
      content: const Text(
          'Please allow the app to access your location all the time.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            openAppSettings();
          },
          child: const Text('SETTINGS'),
        ),
      ],
    ),
  );
}

/* Future<void> trunOnLocation(BuildContext context) async {
  Geolocator.requestPermission();
  // Check if location services are enabled
  bool locationEnabled = await Geolocator.isLocationServiceEnabled();
  if (!locationEnabled) {
    Geolocator.checkPermission();
    // If location services are not enabled, prompt the user to turn them on
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Turn on location services"),
        content: const Text("This app needs location services to work."),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              // Close the dialog and open the device settings to turn on location services
              Navigator.of(context, rootNavigator: true).pop();
              Geolocator.openLocationSettings();
              if (locationEnabled) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  } else {}
} */
