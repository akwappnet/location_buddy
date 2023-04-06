// ignore_for_file: unused_element

import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'dart:ui' as ui;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_buddy/provider/live_traking_view_provider.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/constants.dart';
import 'package:location_buddy/widgets/loading_map.dart';
import 'package:provider/provider.dart';
import '../localization/app_localization.dart';
import '../models/location_data_navigate.dart';
import '../utils/assets/assets_utils.dart';
import '../utils/routes/routes_name.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_dialog_box.dart';

class LiveTracking extends StatefulWidget {
  const LiveTracking({super.key});

  @override
  State<LiveTracking> createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  Location location = Location();

  late StreamSubscription<LocationData> locationSubscription;

  LocationDataNavigate? destination;
  //location of device
  LocationData? currentLocation;
  LocationDataNavigate? _destination;
  final Completer<GoogleMapController> _controller = Completer();

  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  String? length;
  //store image in Uint8List
  late final Uint8List sourceIconTracking, destinationIconTracking;
  PolylineId? _polylineId;
  double totalDistance = 0;

  @override
  void initState() {
    super.initState();
    _destination = Provider.of<LiveTrackingViewProvider>(context, listen: false)
        .locationData;
    setCustomMarkerIcon();
    updateUI();
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }

//set Custom Marker Icon
  void setCustomMarkerIcon() async {
    sourceIconTracking = await getBytesFromAsset(
        path: AssetsUtils.source, //paste the custom image path
        width: 70 // size of custom image as marker
        );
    destinationIconTracking = await getBytesFromAsset(
        path: AssetsUtils.destination, //paste the custom image path
        width: 70 // size of custom image as marker
        );
  }

//function for changing the  image size
  Future<Uint8List> getBytesFromAsset({String? path, int? width}) async {
    ByteData data = await rootBundle.load(path!);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<void> updateUI() async {
    location.getLocation().then((location) {
      currentLocation = location;
      setState(() {});

      dev.log("oldLoc latitude--->${currentLocation!.latitude}");
      dev.log(" oldLoc longitude--->${currentLocation!.longitude}");
    });

    locationSubscription = location.onLocationChanged.listen((newLoc) async {
      //update the current location of the device and update the polyline
      dev.log("newLoc latitude--->${newLoc.latitude!}");
      dev.log(" newLoc longitude--->${newLoc.longitude}");
      currentLocation = newLoc;

      setState(() {});
    });

    GoogleMapController googleMapController = await _controller.future;
    _updatePolyline(googleMapController);
//
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            zoom: 18,
            target: LatLng(
                currentLocation!.latitude!, currentLocation!.longitude!))));
  }
  // calculateDistance in km

  double calculateDistance(LatLng location1, LatLng location2) {
    const double earthRadius = 6371.0; // in km
    double lat1 = location1.latitude * math.pi / 180.0;
    double lon1 = location1.longitude * math.pi / 180.0;
    double lat2 = location2.latitude * math.pi / 180.0;
    double lon2 = location2.longitude * math.pi / 180.0;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = math.pow(math.sin(dLat / 2), 2) +
        math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    double distanceInKm = earthRadius * c;

    return distanceInKm;
  }

  void _updatePolyline(GoogleMapController controller) async {
    if (currentLocation != null) {
      PolylinePoints polylinePoints = PolylinePoints();
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          google_api_key,
          PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          PointLatLng(_destination!.latitude, _destination!.longitude),
          optimizeWaypoints: true,
          travelMode: TravelMode.walking);

      double distance = calculateDistance(
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        LatLng(_destination!.latitude, _destination!.longitude),
      );
      if (distance <= 0.10) {
        // ignore: use_build_context_synchronously

        // show pop-up when distance is less than or equal to 10 meters

        // ignore: use_build_context_synchronously

        // ignore: use_build_context_synchronously
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                heading: "Location Buddy",
                icon: const Icon(Icons.done),
                backgroundColor: CustomColor.primaryColor,
                title: "You have reached your destination!",
                descriptions: "", //
                btn1Text: "Ok",
                btn2Text: "",

                onClicked: () {
                  locationSubscription.cancel();
                  Navigator.popAndPushNamed(context, RoutesName.bottomBar);
                },
              );
            });
      }

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
    final stop = GestureDetector(
      onTap: () {
        locationSubscription.cancel();
        Navigator.popAndPushNamed(context, RoutesName.bottomBar);
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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Center(child: Maploading()),
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
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  zoom: 18),
              polylines: _polylines,
              markers: {
                Marker(
                    icon: BitmapDescriptor.fromBytes(sourceIconTracking),
                    markerId: const MarkerId("currentLocation"),
                    position: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!)),
                Marker(
                    icon: BitmapDescriptor.fromBytes(destinationIconTracking),
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
