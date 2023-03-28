import 'dart:developer';

import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:location_buddy/widgets/custom_dialog_box.dart';

import '../models/location_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/location_callback_handler.dart';
import '../services/take_location_permission.dart';

class SaveLocationViewProvider extends ChangeNotifier {
  final TextEditingController savePointDestinationController =
      TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  List<LocationInfo> _locationInfo = [];
  bool _isLoading = false;
  bool _isSaving = false;

  List<LocationInfo> get locationInfo => _locationInfo;

  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? _currentAddress;
  LocationDto? _currentLocation;
  bool? _isRunningSerives;

  String? _destinationLocationlongitude;
  String? _destinationLocationLatitude;

  bool? get isRunningSerives => _isRunningSerives;
  String? get currentAddress => _currentAddress;
  LocationDto? get currentLocation => _currentLocation;
  String? get destinationLocationlongitude => _destinationLocationlongitude;
  String? get destinationLocationLatitude => _destinationLocationLatitude;

  void setDestinationLocationlongitude(String destinationLocationlongitude) {
    _destinationLocationlongitude = destinationLocationlongitude;
    notifyListeners();
  }

  void setDestinationLocationLatitude(String destinationLocationLatitude) {
    _destinationLocationLatitude = destinationLocationLatitude;
    notifyListeners();
  }

  void setIsRunningSerives(bool isRunningSerives) {
    _isRunningSerives = isRunningSerives;
    notifyListeners();
  }

  void setCurretLocation(LocationDto currentLocation) {
    _currentLocation = currentLocation;
    notifyListeners();
  }

  void setCurretAddress(String currentAddress) {
    _currentAddress = currentAddress;
    notifyListeners();
  }

  void addLocationInfo(LocationInfo locationInfo) {
    _locationInfo.add(locationInfo);
    notifyListeners();
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  void setSaving(bool isSaving) {
    _isSaving = isSaving;
    notifyListeners();
  }

//it will fetch loction data from firebase

  Future<void> fetchLocationInformation() async {
    setLoading(true);
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('locationInfo')
        .get();
    final locationInfo = snapshot.docs
        .map((doc) => LocationInfo(
              savePointDestination: doc['savePointDestination'],
              sourceLocation: doc['sourceLocation'],
              destinationLocation: doc['destinationLocation'],
              sourceLocationLatitude: doc['sourceLocationLatitude'],
              sourceLocationlongitude: doc['sourceLocationlongitude'],
              destinationLocationlongitude: doc['destinationLocationlongitude'],
              destinationLocationLatitude: doc['destinationLocationLatitude'],
              id: doc['id'],
              userId: doc['userId'],
            ))
        .toList();
    _locationInfo = locationInfo;
    setLoading(false);
    notifyListeners();
  }

//store data of location in firebase collection
  Future<void> saveLocationToCollection(
      String savePointDestination,
      String sourceLocation,
      String destinationLocation,
      BuildContext context) async {
    if (savePointDestination.isNotEmpty &&
        sourceLocation.isNotEmpty &&
        destinationLocation.isNotEmpty) {
      setSaving(true);
      final locationInfo = LocationInfo(
          savePointDestination: savePointDestination,
          sourceLocation: sourceLocation,
          destinationLocation: destinationLocation);
      addLocationInfo(locationInfo);

      final docRef = firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('locationInfo')
          .doc();
      await docRef.set({
        'savePointDestination': savePointDestination,
        'sourceLocation': sourceLocation,
        'destinationLocation': destinationLocation,
        'createdAt': DateTime.now().toString(),
        'sourceLocationLatitude': currentLocation!.latitude.toString(),
        'sourceLocationlongitude': currentLocation!.longitude.toString(),
        'destinationLocationLatitude':
            destinationLocationLatitude ?? currentLocation!.latitude.toString(),
        'destinationLocationlongitude': destinationLocationlongitude ??
            currentLocation!.longitude.toString(),
        'id': docRef.id,
        'userId': _auth.currentUser?.uid ?? "",
      }).then(
        (value) {
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black38,
            builder: (BuildContext context) {
              return const CustomDialogBox(
                heading: "Success",
                icon: Icon(Icons.done),
                backgroundColor: CustomColor.violetSecond,
                title: "Location Saved successful",
                descriptions: "", //
                btn1Text: "",
                btn2Text: "",
              );
            },
          );
          Future.delayed(const Duration(milliseconds: 2000)).then((value) =>
              Navigator.popAndPushNamed(context, RoutesName.bottomBar));
        },
      );
      setSaving(false);
      fetchLocationInformation();
      savePointDestinationController.clear();
      sourceController.clear();
      destinationController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: CustomColor.redColor,
          content: Text('Please fill all fields...'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

//delete saved location by id
  Future<void> deleteLocationInformation(String id) async {
    await firestore
        .collection('users')
        .doc(_auth.currentUser?.uid)
        .collection('locationInfo')
        .doc(id)
        .delete();
    _locationInfo
        .removeWhere((locationInfo) => locationInfo.destinationLocation == id);
    fetchLocationInformation();
    notifyListeners();
  }

  Future<void> _getAddressFromLatLng(LocationDto position) async {
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setCurretAddress(
          ' ${place.street} ${place.name} ${place.country} ${place.postalCode}');
      log("----currentAddress----->${_currentAddress.toString()}");
      sourceController.text = _currentAddress.toString();
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> updateUI(dynamic data) async {
    LocationDto? locationDto =
        (data != null) ? LocationDto.fromJson(data) : null;
    await updateNotificationText(locationDto!);
    setCurretLocation(locationDto);
    _getAddressFromLatLng(locationDto);

    try {
      FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': currentLocation!.latitude,
        'longitude': currentLocation!.longitude,
        'name': 'Ram Ghumaliya',
        'datetime': DateTime.now(),
      }, SetOptions(merge: false));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateNotificationText(LocationDto data) async {
    // ignore: unnecessary_null_comparison
    if (data == null) {
      return;
    }

    await BackgroundLocator.updateNotificationText(
        title: "new location received",
        msg: "${DateTime.now()}",
        bigMsg: "${data.latitude}, ${data.longitude}");
  }

  Future<void> initPlatformState() async {
    log('Initializing...');

    await BackgroundLocator.initialize();
    log('Initialization done');
    final isRunning = await BackgroundLocator.isServiceRunning();
    setIsRunningSerives(isRunning);
    log('Running ${isRunningSerives.toString()}');
  }

  Future<void> onStart(BuildContext context) async {
    log("------onStart----->");
    await requestLocationPermission(context);
    // ignore: use_build_context_synchronously
    await trunOnLocation(context);
    await startLocator();
    final isRunning = await BackgroundLocator.isServiceRunning();
    log("------Stat----->$isRunning");
  }

  void onStop(BuildContext context) async {
    await BackgroundLocator.unRegisterLocationUpdate();
    final isRunning = await BackgroundLocator.isServiceRunning();
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: CustomColor.Violet,
        content: Text('Location Services Stoped'),
        duration: Duration(seconds: 3),
      ),
    );
    log("------stop----->$isRunning");
  }

  Future<void> startLocator() async {
    Map<String, dynamic> data = {'countInit': 1};
    return await BackgroundLocator.registerLocationUpdate(
        LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: const IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            distanceFilter: 0,
            stopWithTerminate: false),
        autoStop: false,
        androidSettings: const AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 5,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                    'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIconColor: Color(0xFF08957D),
                notificationTapCallback:
                    LocationCallbackHandler.notificationCallback)));
  }
}
