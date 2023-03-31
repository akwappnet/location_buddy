// ignore_for_file: unused_element

import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

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
import 'package:location_buddy/widgets/loading_map.dart';
import 'package:provider/provider.dart';
import '../localization/app_localization.dart';
import '../models/location_data_navigate.dart';
import '../services/location_service_repository.dart';
import '../widgets/custom_button_widget.dart';

class LiveTracking extends StatefulWidget {
  const LiveTracking({super.key});

  @override
  State<LiveTracking> createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
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

  @override
  void dispose() {
    Provider.of<SaveLocationViewProvider>(context, listen: false)
        .onStop(context);
    super.dispose();
  }

  Future<void> updateUI(dynamic data) async {
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
      southwest: LatLng(min(currentLocation!.latitude, _destination!.latitude),
          min(currentLocation!.longitude, _destination!.longitude)),
      northeast: LatLng(max(currentLocation!.latitude, _destination!.latitude),
          max(currentLocation!.longitude, _destination!.longitude)),
    );

    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            zoom: 18,
            target: LatLng(
                currentLocation!.latitude, currentLocation!.longitude))));
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
    final stop = GestureDetector(
      onTap: () {
        Provider.of<SaveLocationViewProvider>(context, listen: false)
            .onStop(context);
      },
      child: AppButton(
        height: 50.sp,
        sizes: 20.sp,
        text: AppLocalization.of(context)!.translate('stop-tracking'),
        mycolor: CustomColor.primaryColor,
      ),
    );
    final size = SizedBox(height: 40.h);
    final map = currentLocation == null
        ? SizedBox(
            height: 600.h,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 60.h,
                ),
                const Center(child: Maploading()),
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  AppLocalization.of(context)!.translate('save-button2'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28.sp,
                      fontFamily: FontFamliyM.SEMIBOLD,
                      color: CustomColor.primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height / 1.4,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              onCameraMove: (position) {},
              //myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation!.latitude, currentLocation!.longitude),
                  zoom: 18),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        title: Text(
          AppLocalization.of(context)!.translate('live-tracking'),
        ),
      ),
      body: Container(
        color: CustomColor.white,
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(22.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[map, size, stop],
          ),
        ),
      ),
    );
  }
}
