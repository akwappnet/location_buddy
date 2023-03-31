// ignore_for_file: unused_element

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location_buddy/provider/current_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/routes/routes_name.dart';

class SplashViewProvider extends ChangeNotifier {
  Future<void> getLanguage(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lan = prefs.getString("dateFormat") ?? "English";
    log(lan);
    // ignore: use_build_context_synchronously
    final provider = Provider.of<CurrentData>(context, listen: false);
    provider.changeLocale(lan);
  }

  Future<void> checkIfUserIsLoggedIn(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      log(auth.currentUser?.displayName ?? "No name");
      Navigator.popAndPushNamed(context, RoutesName.bottomBar);
    } else {
      Navigator.popAndPushNamed(context, RoutesName.siginView);
    }
  }
}
