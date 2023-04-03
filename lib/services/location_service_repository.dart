import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/location_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class LocationServiceRepository {
  static final LocationServiceRepository _instance =
      LocationServiceRepository._();

  LocationServiceRepository._();

  factory LocationServiceRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';

  int _count = -1;

  Future<void> init(Map<dynamic, dynamic> params) async {
    log("***********Init callback handler");
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> dispose() async {
    log("***********Dispose callback handler");
    log("$_count");

    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> callback(LocationDto locationDto) async {
    log('$_count location in dart----->: ${locationDto.toString()}');
    try {
      Firebase.initializeApp();
      FirebaseFirestore.instance
          .collection('location_from_services')
          .doc('user1')
          .set({
        'latitude': locationDto.latitude,
        'longitude': locationDto.longitude,
        'name': 'Ram Ghumaliya',
        'datetime': DateTime.now(),
      }, SetOptions(merge: false));
    } catch (e) {
      log(e.toString());
    }
    final SendPort? send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(locationDto.toJson());
    _count++;
  }
}
