import 'package:flutter/foundation.dart';
import 'package:location_buddy/models/location_data_navigate.dart';

class LiveTrackingViewProvider extends ChangeNotifier {
  LocationDataNavigate? _locationData;

  LocationDataNavigate get locationData => _locationData!;

  void setLocationData(double latitude, double longitude) {
    _locationData = LocationDataNavigate(latitude, longitude);
    notifyListeners();
  }
}
