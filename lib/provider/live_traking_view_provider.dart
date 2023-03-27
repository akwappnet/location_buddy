// ignore_for_file: unused_element

import 'dart:async';

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/location_data_navigate.dart';
import '../utils/assets/assets_utils.dart';

class LiveTrackingViewProvider extends ChangeNotifier {
  late final Uint8List currentLocationIcon, destinationIcon;

  LocationData? _locationData;

  LocationData get locationData => _locationData!;

  void setLocationData(double latitude, double longitude) {
    _locationData = LocationData(latitude, longitude);
    notifyListeners();
  }

//set Custom Marker Icon
  void setCustomMarkerIcon() async {
    currentLocationIcon = await getBytesFromAsset(
        path: AssetsUtils.source, //paste the custom image path
        width: 70 // size of custom image as marker
        );

    destinationIcon = await getBytesFromAsset(
        path: AssetsUtils
            .destination, //paste the custom image path//paste the custom image path
        width: 70 // size of custom image as marker
        );
  }

  //function for changing the  image size
  Future<Uint8List> getBytesFromAsset({String? path, int? width}) async {
    ByteData data = await rootBundle.load(path!);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
