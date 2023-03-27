import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;

  LatLng source = const LatLng(37.4219999, -122.0840575);
  LatLng destination = const LatLng(37.42796133580664, -122.085749655962);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: source,
          zoom: 14,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;

          _centerViewOnMarkers();
        },
        markers: {
          Marker(
            markerId: const MarkerId('source'),
            position: source,
          ),
          Marker(
            markerId: const MarkerId('destination'),
            position: destination,
          ),
        },
      ),
    );
  }

  Future<void> _centerViewOnMarkers() async {
    await Future.delayed(const Duration(milliseconds: 100));

    final distanceInMeters = Geolocator.distanceBetween(
      source.latitude,
      source.longitude,
      destination.latitude,
      destination.longitude,
    );

    final centerLat = (source.latitude + destination.latitude) / 2;
    final centerLng = (source.longitude + destination.longitude) / 2;
    final center = LatLng(centerLat, centerLng);

    final zoomLevel = _getZoomLevel(distanceInMeters);

    _controller.animateCamera(
      CameraUpdate.newLatLngZoom(center, zoomLevel),
    );
  }

  double _getZoomLevel(double distance) {
    if (distance > 2000) {
      return 9;
    } else if (distance > 1000) {
      return 10;
    } else if (distance > 500) {
      return 11;
    } else if (distance > 250) {
      return 12;
    } else if (distance > 100) {
      return 13;
    } else {
      return 14;
    }
  }
  /* late GoogleMapController _controller;
  late LatLngBounds _bounds;
  late CameraUpdate _cameraUpdate;
  LatLng source = LatLng(37.4219999, -122.0840575);
  LatLng destination = LatLng(38.42796133580664, -122.085749655962);

  @override
  void initState() {
    super.initState();
    _bounds = _getBounds();
    _cameraUpdate = CameraUpdate.newLatLngBounds(_bounds, 50);
  }

  LatLngBounds _getBounds() {
    double minLat = (source.latitude < destination.latitude)
        ? source.latitude
        : destination.latitude;
    double minLng = (source.longitude < destination.longitude)
        ? source.longitude
        : destination.longitude;
    double maxLat = (source.latitude > destination.latitude)
        ? source.latitude
        : destination.latitude;
    double maxLng = (source.longitude > destination.longitude)
        ? source.longitude
        : destination.longitude;

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _controller.animateCamera(_cameraUpdate);
  }

  double _calculateDistance() {
    const int earthRadius = 6371;
    double lat1 = source.latitude;
    double lon1 = source.longitude;
    double lat2 = destination.latitude;
    double lon2 = destination.longitude;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    lat1 = _toRadians(lat1);
    lat2 = _toRadians(lat2);

    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map')),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: source,
          zoom: 12,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('source'),
            position: source,
            infoWindow: const InfoWindow(title: 'Source'),
          ),
          Marker(
            markerId: const MarkerId('destination'),
            position: destination,
            infoWindow: const InfoWindow(title: 'Destination'),
          ),
        },
      ),
      bottomSheet: Container(
        height: 50,
        alignment: Alignment.center,
        child: Text(
          'Distance: ${_calculateDistance().toStringAsFixed(2)} km',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  } */
}
