import 'dart:async';
import 'dart:math';

import 'dart:developer' as logdev;

import 'dart:developer' as dev;
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_buddy/utils/assets/assets_utils.dart';
import 'package:provider/provider.dart';

import 'dart:ui' as ui;

import '../localization/app_localization.dart';
import '../models/location_data_navigate.dart';
import '../provider/live_traking_view_provider.dart';
import '../utils/colors/colors.dart';
import '../utils/constants.dart';
import '../utils/font/font_family.dart';
import '../utils/routes/routes_name.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/loading_map.dart';

class LiveTrackingPageExtra extends StatefulWidget {
  const LiveTrackingPageExtra({Key? key}) : super(key: key);

  @override
  State<LiveTrackingPageExtra> createState() => LiveTrackingPageExtraState();
}

class LiveTrackingPageExtraState extends State<LiveTrackingPageExtra> {
  Location location = Location();

  late StreamSubscription<LocationData> locationSubscription;

  //location of device
  LocationData? currentLocation;

  LocationDataNavigate? destination;
  final Completer<GoogleMapController> _controller = Completer();

  final Set<Polyline> _polylines = {};
  final List<LatLng> _polylineCoordinates = [];
  String? length;
  double? totalDistanceInKm;
  PolylineId? _polylineId;
  double estimatedTimeInMinutes = 0;
  var count = 0;
//  bool val = true;
  dynamic result = '';

  //store image in Uint8List
  late final Uint8List sourceIconPage, destinationIconPage;
  @override
  void initState() {
    destination = Provider.of<LiveTrackingViewProvider>(context, listen: false)
        .locationData;
    logdev.log('Latitude: ${destination!.latitude}');
    logdev.log('Longitude: ${destination!.longitude}');
    getCurrentLocation();
    setCustomMarkerIcon();
    super.initState();
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }

  //get the current location of the device and animate the camera to the current location
  void getCurrentLocation() async {
    PermissionStatus permissionGranted;
    bool serviceEnabled;

    //check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      //request to enable location service
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    //check if location permission is granted
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      //request to grant location permission
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    //get the current location of the device and animate the camera to the current location
    location.getLocation().then((location) {
      currentLocation = location;
      setState(() {});

      logdev.log("oldLoc latitude--->${currentLocation!.latitude}");
      logdev.log(" oldLoc longitude--->${currentLocation!.longitude}");
    });

    locationSubscription = location.onLocationChanged.listen((newLoc) async {
      calculateTimeAndDis();
      //update the current location of the device and update the polyline
      dev.log("newLoc latitude--->${newLoc.latitude!}");
      dev.log(" newLoc longitude--->${newLoc.longitude}");
      currentLocation = newLoc;

      setState(() {});

      GoogleMapController googleMapController = await _controller.future;
      _updatePolyline(googleMapController);

      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
            min(currentLocation!.latitude!, destination!.latitude),
            min(currentLocation!.longitude!, destination!.longitude)),
        northeast: LatLng(
            max(currentLocation!.latitude!, destination!.latitude),
            max(currentLocation!.longitude!, destination!.longitude)),
      );

      googleMapController
          .animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    });
  }

  void calculateTimeAndDis() {
    setState(() {
      LatLng location1 =
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
      LatLng location2 = LatLng(destination!.latitude, destination!.longitude);
      totalDistanceInKm = calculateDistance(location1, location2);
      dev.log("-------------->$totalDistanceInKm km");

      double walkingSpeed = 1.2; // m/s
      double totalDistanceInMeters = totalDistanceInKm! * 1000;
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
          PointLatLng(destination!.latitude, destination!.longitude),
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
            width: 6,
            polylineId: _polylineId!,
            color: CustomColor.secondaryColor,
            points: _polylineCoordinates,
            visible: true,
            patterns: [PatternItem.dot, PatternItem.gap(15)],
          ));
        });
      }
    }
  }

//set Custom Marker Icon
  void setCustomMarkerIcon() async {
    sourceIconPage = await getBytesFromAsset(
        path: AssetsUtils.source, //paste the custom image path
        width: 70.sp.toInt() // size of custom image as marker
        );
    destinationIconPage = await getBytesFromAsset(
        path: AssetsUtils.destination, //paste the custom image path
        width: 75.sp.toInt() // size of custom image as marker
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

  @override
  Widget build(BuildContext context) {
    //_retrieveLocationData();

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
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  zoom: 16),
              polylines: _polylines,
              markers: {
                Marker(
                    icon: BitmapDescriptor.fromBytes(sourceIconPage),
                    markerId: const MarkerId("source"),
                    position: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!)),
                Marker(
                    icon: BitmapDescriptor.fromBytes(destinationIconPage),
                    markerId: const MarkerId("destination"),
                    position:
                        LatLng(destination!.latitude, destination!.longitude))
              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
          );
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
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
                totalDistanceInKm == null
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
                              'Distance: ${(totalDistanceInKm!).toStringAsFixed(2)} km',
                              style: TextStyle(
                                  color: CustomColor.white,
                                  fontFamily: FontFamliyM.ROBOTOREGULAR,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    Navigator.popAndPushNamed(
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
        ));
  }
}
