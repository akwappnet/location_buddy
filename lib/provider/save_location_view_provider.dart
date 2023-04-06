import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location_buddy/helper/loading_dialog.dart';
import 'package:location_buddy/localization/app_localization.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:location_buddy/widgets/custom_dialog_box.dart';

import 'package:location/location.dart' as loc;

import '../models/location_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/take_location_permission.dart';

class SaveLocationViewProvider extends ChangeNotifier {
  final TextEditingController savePointDestinationController =
      TextEditingController();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  List<LocationInfo> _locationInfo = [];

  loc.Location location = loc.Location();

  //location of device
  loc.LocationData? _currentLocation;
  bool _isLoading = false;
  bool _isSaving = false;

  List<LocationInfo> get locationInfo => _locationInfo;

  bool get isLoading => _isLoading;

  bool get isSaving => _isSaving;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? _currentAddress;
//  geo.Position? _currentPosition;

  bool? _isRunningSerives;

  String? _destinationLocationlongitude;
  String? _destinationLocationLatitude;

  bool? get isRunningSerives => _isRunningSerives;
  String? get currentAddress => _currentAddress;
  loc.LocationData? get currentLocation => _currentLocation;
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

  void setCurrentPosition(loc.LocationData? currentLocation) {
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
        'sourceLocationLatitude': _currentLocation!.latitude.toString(),
        'sourceLocationlongitude': _currentLocation!.longitude.toString(),
        'destinationLocationLatitude': destinationLocationLatitude ??
            _currentLocation!.latitude.toString(),
        'destinationLocationlongitude': destinationLocationlongitude ??
            _currentLocation!.longitude.toString(),
        'id': docRef.id,
        'userId': _auth.currentUser?.uid ?? "",
        'userName': _auth.currentUser?.displayName ?? "",
        'userEmail': _auth.currentUser?.email ?? "",
      }).then(
        (value) {
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black38,
            builder: (BuildContext context) {
              return CustomDialogBox(
                heading: AppLocalization.of(context)!.translate('success'),
                icon: const Icon(Icons.done),
                backgroundColor: CustomColor.primaryColor,
                title:
                    AppLocalization.of(context)!.translate('save-successfull'),
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

      savePointDestinationController.clear();
      sourceController.clear();
      destinationController.clear();
      await fetchLocationInformation();
      setSaving(false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: CustomColor.redColor,
          content: Text(AppLocalization.of(context)!.translate('empty-field')),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

//delete saved location by id
  Future<void> deleteLocationInformation(
      String id, BuildContext context) async {
    try {
      showCustomLoadingDialog(context);
      await firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('locationInfo')
          .doc(id)
          .delete();
      _locationInfo.removeWhere(
          (locationInfo) => locationInfo.destinationLocation == id);
      // ignore: use_build_context_synchronously
      await closeCustomLoadingDialog(context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      await fetchLocationInformation();
      // ignore: use_build_context_synchronously

      notifyListeners();
    } catch (e) {
      closeCustomLoadingDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: CustomColor.redColor,
          content: Text(
            AppLocalization.of(context)!.translate('error-data-delete'),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      log('Error deleting account: $e');
    }
  }

//get current location and convert to address

  Future<void> getAdderss() async {
    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    if (serviceEnabled) {
      await location.getLocation().then((location) async {
        setCurrentPosition(location);

        log("oldLoc latitude--->${_currentLocation!.latitude}");
        log(" oldLoc longitude--->${_currentLocation!.latitude}");

        List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude!, location.longitude!);
        Placemark placemark = placemarks[0];
        String address =
            '${placemark.street},${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
        log("----currentAddress----->${address.toString()}");

        sourceController.text = address;
      });
      return;
    } else {
      return;
    }
  }

  Future<void> getCurrentLocation(BuildContext context) async {
//    await locationPermission(context);

    loc.PermissionStatus permissionGranted;
    bool serviceEnabled;

    //check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      //request to enable location service
      serviceEnabled = await location.requestService();
      if (serviceEnabled) {
        await getAdderss();
        print("object");
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text("Please Turn on Location"),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
    await getAdderss();

    //  getAdderss();
    //check if location permission is granted
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      //request to grant location permission
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text("Please Give Location Permission"),
            duration: Duration(seconds: 3),
          ),
        );
        log("message");
        return;
      }
    }

    await getAdderss();
  }
}
