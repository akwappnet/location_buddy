// ignore_for_file: unused_element

import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'dart:developer' as dev;

import 'package:background_locator_2/location_dto.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_buddy/provider/live_traking_view_provider.dart';
import 'package:location_buddy/provider/save_location_view_provider.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/constants.dart';
import 'package:location_buddy/utils/font/font_family.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:location_buddy/widgets/loading_map.dart';
import 'package:provider/provider.dart';
import '../localization/app_localization.dart';
import '../models/location_data_navigate.dart';
import '../services/location_service_repository.dart';
import '../widgets/custom_button_widget.dart';

class LiveTrackingPage extends StatefulWidget {
  const LiveTrackingPage({super.key});

  @override
  State<LiveTrackingPage> createState() => _LiveTrackingPageState();
}

class _LiveTrackingPageState extends State<LiveTrackingPage> {
  ReceivePort port = ReceivePort();
  LocationDto? currentLocation;

  LocationData? _destination;
  final Completer<GoogleMapController> _controller = Completer();

  //  static const LatLng destination = LatLng(23.0802, 72.5244);
  //store sourceLocation to destination location point to draw line

  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  String? length;

  PolylineId? _polylineId;
  double totalDistance = 0;
  double estimatedTimeInMinutes = 0;
  var count = 0;
  bool val = true;
  dynamic result = '';

  @override
  void initState() {
    super.initState();

    _destination = Provider.of<LiveTrackingViewProvider>(context, listen: false)
        .locationData;
    // log('Latitude: ${_destination!.latitude}');
    // log('Longitude: ${_destination!.longitude}');
    if (IsolateNameServer.lookupPortByName(
            LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }
    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);
    port.listen(
      (dynamic data) async {
        await updateUI(data);
      },
    );
    Provider.of<SaveLocationViewProvider>(context, listen: false)
        .initPlatformState();

    Provider.of<SaveLocationViewProvider>(context, listen: false)
        .onStart(context);

    Provider.of<LiveTrackingViewProvider>(context, listen: false)
        .setCustomMarkerIcon();
  }

  Future<void> updateUI(dynamic data) async {
    if (count == 1) {
      val = false;
    }
    if (count <= 1) {
      LocationDto? locationDto =
          (data != null) ? LocationDto.fromJson(data) : null;

      setState(() {
        if (data != null) {
          currentLocation = locationDto;
        }
      });

      GoogleMapController googleMapController = await _controller.future;
      _updatePolyline(googleMapController);

      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
            min(currentLocation!.latitude, _destination!.latitude),
            min(currentLocation!.longitude, _destination!.longitude)),
        northeast: LatLng(
            max(currentLocation!.latitude, _destination!.latitude),
            max(currentLocation!.longitude, _destination!.longitude)),
      );

      googleMapController
          .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
      calculateDistanceAndTime();
      dev.log('======$count');
      count++;
    }
  }

  void calculateDistanceAndTime() {
    if (count == 1) {
      setState(() {
        for (int i = 0; i < _polylineCoordinates.length - 1; i++) {
          LatLng start = _polylineCoordinates[i];
          LatLng end = _polylineCoordinates[i + 1];
          double distance = Geolocator.distanceBetween(
              start.latitude, start.longitude, end.latitude, end.longitude);
          totalDistance += distance;
        }
        dev.log(
            'Total Distance: ${(totalDistance / 1000).toStringAsFixed(2)} km');
        double walkingSpeed = 1.2; // m/s
        double totalDistanceInMeters = totalDistance;
        estimatedTimeInMinutes = (totalDistanceInMeters / walkingSpeed) / 60;

        if (estimatedTimeInMinutes < 60) {
          dev.log(
              'Estimated Time: ${estimatedTimeInMinutes.toStringAsFixed(0)} min');
        } else {
          int hours = estimatedTimeInMinutes ~/ 60;
          int minutes = estimatedTimeInMinutes.toInt() % 60;
          result = '${hours}h ${minutes}m';
          dev.log('Estimated Time: $result');
        }
      });
    }
  }

  void _updatePolyline(GoogleMapController controller) async {
    if (currentLocation != null) {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          google_api_key,
          PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
          PointLatLng(_destination!.latitude, _destination!.longitude),
          optimizeWaypoints: true,
          travelMode: TravelMode.walking);

      if (result.points.isNotEmpty) {
        _polylineCoordinates.clear();
        for (var point in result.points) {
          _polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }

        setState(() {
          if (_polylineId != null) {
            _polylines.removeWhere(
                (Polyline polyline) => polyline.polylineId == _polylineId);
          }

          _polylineId = const PolylineId('route');
          _polylines.add(Polyline(
            geodesic: true,
            width: 10,
            polylineId: _polylineId!,
            color: CustomColor.primaryColor,
            points: _polylineCoordinates,
            visible: true,
            patterns: [PatternItem.dot, PatternItem.gap(15)],
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final liveTrackingViewProvider =
        Provider.of<LiveTrackingViewProvider>(context);

    final size = SizedBox(height: 40.h);
    final map = currentLocation == null
        ? SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Center(child: Maploading()),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              //myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.terrain,

              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation!.latitude, currentLocation!.longitude),
                  zoom: 16),
              polylines: _polylines,
              markers: {
                Marker(
                    icon: BitmapDescriptor.fromBytes(
                        liveTrackingViewProvider.currentLocationIcon),
                    markerId: const MarkerId("currentLocation"),
                    position: LatLng(
                        currentLocation!.latitude, currentLocation!.longitude)),
                Marker(
                    icon: BitmapDescriptor.fromBytes(
                        liveTrackingViewProvider.destinationIcon),
                    markerId: const MarkerId("destination"),
                    position:
                        LatLng(_destination!.latitude, _destination!.longitude))
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
          );

    return WillPopScope(
      onWillPop: () {
        Provider.of<SaveLocationViewProvider>(context, listen: false)
            .onStop(context);
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Provider.of<SaveLocationViewProvider>(context, listen: false)
                      .onStop(context);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: CustomColor.white,
                )),
            backgroundColor: CustomColor.primaryColor,
            title: Text(
              AppLocalization.of(context)!.translate('live-tracking'),
            ),
          ),
          body: Container(
            color: CustomColor.white,
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  map,
                  size,
                  val
                      ? Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          height: 150,
                          decoration: const BoxDecoration(
                              color: CustomColor.primaryColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(31),
                                  topLeft: Radius.circular(31))),
                          child: Center(
                            child: Text(
                              "Please Wait.....",
                              style: TextStyle(
                                  color: CustomColor.white,
                                  fontFamily: FontFamliyM.ROBOTOREGULAR,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.sp),
                          height: 150,
                          decoration: const BoxDecoration(
                              color: CustomColor.primaryColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(31),
                                  topLeft: Radius.circular(31))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Distance: ${(totalDistance / 1000).toStringAsFixed(2)} km',
                                style: TextStyle(
                                    color: CustomColor.white,
                                    fontFamily: FontFamliyM.ROBOTOREGULAR,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      estimatedTimeInMinutes < 60
                                          ? 'Estimated Time: ${estimatedTimeInMinutes.toStringAsFixed(0)} min'
                                          : 'Estimated Time: $result',
                                      style: TextStyle(
                                          color: CustomColor.white,
                                          fontFamily: FontFamliyM.ROBOTOREGULAR,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold)),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, RoutesName.livetracking);
                                    },
                                    child: AppButton(
                                        mycolor: CustomColor.secondaryColor,
                                        width: 100.w,
                                        height: 30.h,
                                        text: 'Start'),
                                  ),
                                ],
                              ),
                            ],
                          ))
                ],
              ),
            ),
          )),
    );
  }
}
