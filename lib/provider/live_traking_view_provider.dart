// ignore_for_file: unused_element

import 'dart:async';

import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:location_buddy/models/location_data_navigate.dart';

import '../utils/assets/assets_utils.dart';

class LiveTrackingViewProvider extends ChangeNotifier {
  LocationDataNavigate? _locationData;

  LocationDataNavigate get locationData => _locationData!;

  void setLocationData(double latitude, double longitude) {
    _locationData = LocationDataNavigate(latitude, longitude);
    notifyListeners();
  }

  Uint8List? destinationIcon, currentLocationIcon;
//set Custom Marker Icon
  void setCustomMarkerIcon() async {
    destinationIcon = await getBytesFromAsset(
        path: AssetsUtils
            .destination, //paste the custom image path//paste the custom image path
        width: 70 // size of custom image as marker
        );

    currentLocationIcon = await getBytesFromAsset(
        path: AssetsUtils.source, //paste the custom image path
        width: 60 // size of custom image as marker
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
