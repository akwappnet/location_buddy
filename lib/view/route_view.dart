import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/location_dto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_buddy/utils/assets/assets_utils.dart';
import 'package:location_buddy/utils/colors/colors.dart';

class RouteView extends StatefulWidget {
  const RouteView({super.key});

  @override
  State<RouteView> createState() => _RouteViewState();
}

class _RouteViewState extends State<RouteView> {
  @override
  void initState() {
    super.initState();
    //  getPolyPoints();
    _getPolyline();
    getCurrentLocation();
    //setCustomMarkerIcon();
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
        "AIzaSyAERKSFYMxdSR6mrMmgyesmQOr8miAFd4c",
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
            color: CustomColor.Violet,
            points: _polylineCoordinates));
      });
    }
  }

  void _updatePolyline(GoogleMapController controller) async {
    if (currentLocation != null) {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          "AIzaSyAERKSFYMxdSR6mrMmgyesmQOr8miAFd4c",
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
              color: CustomColor.Violet,
              points: _polylineCoordinates));
        });
      }
    }
  }

  /* void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(500, 500)), AssetsUtils.source)
        .then(
      (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(500, 500)),
            AssetsUtils.destination)
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );
  } */

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColor.Violet,
          title: const Text(
            "Track order",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(sourceLocation.latitude, sourceLocation.longitude),
              zoom: 16),
          polylines: _polylines,
          markers: {
            Marker(
                icon: currentLocationIcon,
                markerId: const MarkerId("currentLocation"),
                position:
                    LatLng(sourceLocation.latitude, sourceLocation.longitude)),
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

  /*  @override
  Widget build(BuildContext context) {
    final map = SizedBox(
      height: 400,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        //myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.terrain,
        initialCameraPosition: CameraPosition(
            target: LatLng(sourceLocation.latitude, sourceLocation.longitude),
            zoom: 16),
        polylines: _polylines,
        markers: {
          Marker(
              icon: BitmapDescriptor.fromBytes(scorceIcon),
              markerId: const MarkerId("currentLocation"),
              position:
                  LatLng(sourceLocation.latitude, sourceLocation.longitude)),
          Marker(
              icon: BitmapDescriptor.fromBytes(destinationIcon),
              markerId: const MarkerId("destination"),
              position: destination),
        },
        onMapCreated: (mapController) {
          _controller.complete(mapController);
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.Violet,
        title: const Text('Live Tracking'),
      ),
      body: Container(
        color: const Color.fromRGBO(240, 240, 240, 1),
        width: double.maxFinite,
        padding: const EdgeInsets.all(22),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              map,
            ],
          ),
        ),
      ),
    );
  } */
}
