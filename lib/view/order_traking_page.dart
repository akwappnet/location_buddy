import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../utils/constants.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  @override
  void initState() {
    //  getPolyPoints();
    _getPolyline();
    getCurrentLocation();
    setCustomMarkerIcon();
    super.initState();
  }

  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng destination = LatLng(23.0708, 72.5177);
  static const LatLng sourceLocation = LatLng(23.0799, 72.5014);
  //store sourceLocation to destination location point to draw line
  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  PolylineId? _polylineId;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  //location of device
  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
    });
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen((newLoc) {
      currentLocation = newLoc;
      _updatePolyline(googleMapController);
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            zoom: 16,
            target: LatLng(
              newLoc.latitude!,
              newLoc.longitude!,
            )),
      ));
      setState(() {});
    });
  }

  Future<void> _getPolyline() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(destination.latitude, destination.longitude));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.clear();
        _polylineCoordinates.clear();
        _polylineId = const PolylineId('route');
        _polylines.add(Polyline(
            width: 5,
            polylineId: _polylineId!,
            color: primaryColor,
            points: _polylineCoordinates));
      });
    }
  }

  void _updatePolyline(GoogleMapController controller) async {
    if (currentLocation != null) {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          google_api_key,
          PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          PointLatLng(destination.latitude, destination.longitude));
      if (result.points.isNotEmpty) {
        _polylineCoordinates.clear();
        result.points.forEach((PointLatLng point) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });

        setState(() {
          if (_polylineId != null) {
            _polylines.removeWhere(
                (Polyline polyline) => polyline.polylineId == _polylineId);
          }
          _polylineId = const PolylineId('route');
          _polylines.add(Polyline(
              width: 5,
              polylineId: _polylineId!,
              color: primaryColor,
              points: _polylineCoordinates));
        });
      }
    }
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(500, 500)),
            "assets/Pin_source.png")
        .then(
      (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(500, 500)),
            "assets/Pin_destination.png")
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(500, 500)),
            "assets/Pin_current_location.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  // void getPolyPoints() async {
  //   PolylinePoints polylinePoints = PolylinePoints();
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //       google_api_key,
  //       PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
  //       PointLatLng(destination.latitude, destination.longitude));
  //   if (result.points.isNotEmpty) {
  //     result.points.forEach((PointLatLng point) =>
  //         polyLineCoordinates.add(LatLng(point.latitude, point.longitude)));
  //     setState(() {});
  //   }
  //   // Polyline polyline = const Polyline(
  //   //   polylineId: PolylineId('poly'),
  //   //   color: primaryColor,
  //   //   width: 2,
  //   //   points: [
  //   //     LatLng(37.77483, -122.41942),
  //   //     LatLng(37.77483, -122.44942),
  //   //     LatLng(37.78483, -122.44942),
  //   //     LatLng(37.78483, -122.41942),
  //   //   ],
  //   // );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text(
            "Track order",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        body: currentLocation == null
            ? const Center(child: Text("Loading map...."))
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!),
                    zoom: 16),
                // polylines: {
                //   Polyline(
                //       polylineId: const PolylineId("route"),
                //       points: _polylineCoordinates,
                //       color: primaryColor,
                //       width: 20),
                // },
                polylines: _polylines,
                markers: {
                  Marker(
                      icon: currentLocationIcon,
                      markerId: const MarkerId("currentLocation"),
                      position: LatLng(currentLocation!.latitude!,
                          currentLocation!.longitude!)),
                  Marker(
                      icon: sourceIcon,
                      markerId: const MarkerId("source"),
                      position: sourceLocation),
                  Marker(
                      icon: destinationIcon,
                      markerId: const MarkerId("destination"),
                      position: destination)
                },
                onMapCreated: (mapController) {
                  _controller.complete(mapController);
                },
              ));
  }
}
