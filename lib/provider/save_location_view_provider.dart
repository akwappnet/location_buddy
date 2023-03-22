// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:location_buddy/widgets/custom_dialog_box.dart';

import '../models/location_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SaveLocationViewProvider extends ChangeNotifier {
  final TextEditingController savePointSourceController =
      TextEditingController();
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
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String? _currentAddress;
  Position? _currentPosition;

  String? get currentAddress => _currentAddress;
  Position? get currentPosition => _currentPosition;

  void setCurretAddress(String currentAddress) {
    _currentAddress = currentAddress;
    notifyListeners();
  }

  void setCurretPosition(Position currentPosition) {
    _currentPosition = currentPosition;
    notifyListeners();
  }

  void addPerson(LocationInfo person) {
    _locationInfo.add(person);
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
    final snapshot =
        await FirebaseFirestore.instance.collection('location_info').get();
    final locationInfo = snapshot.docs
        .map((doc) => LocationInfo(
              savePointSource: doc['savePointSource'],
              savePointDestination: doc['savePointDestination'],
              sourceLocation: doc['sourceLocation'],
              destinationLocation: doc['destinationLocation'],
              id: doc['id'],
            ))
        .toList();
    _locationInfo = locationInfo;
    setLoading(false);
    notifyListeners();
  }

//store data of location in firebase collection
  Future<void> saveLocationToCollection(
      String savePointSource,
      String savePointDestination,
      String sourceLocation,
      String destinationLocation,
      BuildContext context) async {
    if (savePointSource.isNotEmpty) {
      setSaving(true);
      final locationInfo = LocationInfo(
          savePointSource: savePointSource,
          savePointDestination: savePointDestination,
          sourceLocation: sourceLocation,
          destinationLocation: destinationLocation);
      addPerson(locationInfo);
      final docRef = firestore.collection('location_info').doc();
      await docRef.set({
        'savePointSource': savePointSource,
        'savePointDestination': savePointDestination,
        'sourceLocation': sourceLocation,
        'destinationLocation': destinationLocation,
        'createdAt': DateTime.now().toString(),
        'id': docRef.id,
      }).then(
        (value) {
          showDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: '',
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
      savePointSourceController.clear();
      savePointDestinationController.clear();
      sourceController.clear();
      destinationController.clear();
    }
  }

//delete saved location by id
  Future<void> deleteLocationInformation(String id) async {
    print("-*-------------->$id");
    await firestore.collection('location_info').doc(id).delete();
    _locationInfo
        .removeWhere((locationInfo) => locationInfo.destinationLocation == id);
    fetchLocationInformation();
    notifyListeners();
  }

//handle Location Permission from user

  Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition(BuildContext context) async {
    final hasPermission = await handleLocationPermission(context);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setCurretPosition(position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setCurretAddress(
          ' ${place.street} ${place.name} ${place.country} ${place.postalCode}');
      print(_currentAddress);
      sourceController.text = _currentAddress.toString();
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
