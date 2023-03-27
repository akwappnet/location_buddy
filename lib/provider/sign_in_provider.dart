import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location_buddy/utils/colors/colors.dart';

import '../helper/loading_dialog.dart';
import '../utils/routes/routes_name.dart';
import '../widgets/custom_dialog_box.dart';

class SignInProvider with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  SignInProvider() {
    _checkCurrentUser();
  }

  User? get user => _user;

  Future<void> _checkCurrentUser() async {
    _user = _auth.currentUser;
    notifyListeners();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // ignore: use_build_context_synchronously
      showCustomLoadingDialog(context);
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _user = userCredential.user;
      log("------------->${_user?.displayName.toString()}");
      log("------------->$_auth");
      notifyListeners();
      if (_user != null && _user!.email!.isNotEmpty) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // ignore: prefer_const_constructors
              return CustomDialogBox(
                heading: "Success",
                icon: const Icon(Icons.done),
                backgroundColor: CustomColor.primaryColor,
                title: "Login Successfull",
                descriptions: "", //
                btn1Text: "",
                btn2Text: "",
              );
            });
        await Future.delayed(const Duration(seconds: 2)).then((value) {
          closeCustomLoadingDialog(context);
          Navigator.popAndPushNamed(context, RoutesName.bottomBar);
        });

        // ignore: use_build_conte
      } else {
        // ignore: use_build_context_synchronously
        closeCustomLoadingDialog(context);
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // ignore: prefer_const_constructors
              return CustomDialogBox(
                heading: "Error",
                icon: const Icon(Icons.clear),
                backgroundColor: CustomColor.redColor,
                title: "Somthing went wrong please try again...",
                descriptions: "", //
                btn1Text: "",
                btn2Text: "Ok",
              );
            });
      }
    } catch (e) {
      closeCustomLoadingDialog(context);
      log("------------->$e");
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _user = null;
    // ignore: use_build_context_synchronously
    Navigator.popAndPushNamed(context, RoutesName.siginview);
    notifyListeners();
  }
}
