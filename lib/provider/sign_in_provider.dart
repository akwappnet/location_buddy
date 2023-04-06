// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:location_buddy/utils/colors/colors.dart';

import '../helper/loading_dialog.dart';
import '../localization/app_localization.dart';
import '../utils/routes/routes_name.dart';
import '../widgets/custom_dialog_box.dart';

class SignInProvider with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  TextEditingController signemailController = TextEditingController();
  TextEditingController signpassController = TextEditingController();

  SignInProvider() {
    _checkCurrentUser();
  }

  User? get user => _user;

  Future<void> _checkCurrentUser() async {
    _user = _auth.currentUser;
    notifyListeners();
  }

  void clearText() {
    signemailController.clear();
    signpassController.clear();
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
                heading: AppLocalization.of(context)!.translate('success'),
                icon: const Icon(Icons.done),
                backgroundColor: CustomColor.primaryColor,
                title:
                    AppLocalization.of(context)!.translate('login-successfull'),
                descriptions: "", //
                btn1Text: "",
                btn2Text: "",
              );
            });
        await Future.delayed(const Duration(seconds: 2)).then((value) {
          closeCustomLoadingDialog(context);
          clearText();
          Navigator.popAndPushNamed(context, RoutesName.bottomBar);
        });

        // ignore: use_build_conte
      } else {
        clearText();
        closeCustomLoadingDialog(context);

        showDialog(
            context: context,
            builder: (BuildContext context) {
              // ignore: prefer_const_constructors
              return CustomDialogBox(
                heading: AppLocalization.of(context)!.translate('error'),
                icon: const Icon(Icons.clear),
                backgroundColor: CustomColor.redColor,
                title: AppLocalization.of(context)!.translate('error-somthing'),

                descriptions: "", //
                btn1Text: "",
                btn2Text: AppLocalization.of(context)!.translate('ok'),
              );
            });
      }
    } catch (e) {
      closeCustomLoadingDialog(context);
      clearText();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            // ignore: prefer_const_constructors
            return CustomDialogBox(
              heading: AppLocalization.of(context)!.translate('error'),
              icon: const Icon(Icons.clear),
              backgroundColor: CustomColor.redColor,
              title: AppLocalization.of(context)!.translate('error-somthing'),

              descriptions: "$e", //
              btn2Text: "",
              btn1Text: AppLocalization.of(context)!.translate('ok'),
              onClicked: () {
                signOut(context);
              },
            );
          });
      log("------------->$e");
    }
  }

  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        showCustomLoadingDialog(context);
        final UserCredential userCredential = await _auth
            .signInWithEmailAndPassword(email: email, password: password);
        _user = userCredential.user;
        notifyListeners();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // ignore: prefer_const_constructors
              return CustomDialogBox(
                heading: AppLocalization.of(context)!.translate('success'),
                //heading: "Success",
                icon: const Icon(Icons.done),
                backgroundColor: CustomColor.primaryColor,
                title:
                    AppLocalization.of(context)!.translate('login-successfull'),
                descriptions: "", //
                btn1Text: "",
                btn2Text: "",
              );
            });

        await Future.delayed(const Duration(seconds: 2)).then((value) {
          clearText();
          closeCustomLoadingDialog(context);
          Navigator.popAndPushNamed(context, RoutesName.bottomBar);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text(
              AppLocalization.of(context)!.translate('empty-field'),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        clearText();
        closeCustomLoadingDialog(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text(
              AppLocalization.of(context)!.translate('error-no-user'),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        clearText();
        closeCustomLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text(
              AppLocalization.of(context)!.translate('error-password'),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        log('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        clearText();
        closeCustomLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          // ignore: prefer_const_constructors
          SnackBar(
            backgroundColor: CustomColor.redColor,
            content: const Text("Invalid email format "),
            duration: const Duration(seconds: 3),
          ),
        );
        log('Wrong password provided for that user.');
      } else {
        clearText();
        closeCustomLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          // ignore: prefer_const_constructors
          SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text(
              AppLocalization.of(context)!.translate('error-somthing'),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String password, String name, BuildContext context) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        showCustomLoadingDialog(context);
        final UserCredential userCredential = await _auth
            .createUserWithEmailAndPassword(email: email, password: password);
        _user = userCredential.user;
        notifyListeners();
        try {
          final FirebaseFirestore firestore = FirebaseFirestore.instance;
          final docRef = firestore.collection('usersInfo').doc();
          await docRef.set({
            'id': docRef.id,
            'name': name,
            'email': email,
            'password': password,
            'created_at': DateTime.now(),
          });
        } catch (e) {
          log(e.toString());
        }
        showDialog(
            context: context,
            builder: (BuildContext context) {
              // ignore: prefer_const_constructors
              return CustomDialogBox(
                heading: "Success",
                icon: const Icon(Icons.done),
                backgroundColor: CustomColor.primaryColor,
                title: "Registration Successfull",
                descriptions: "", //
                btn1Text: "",
                btn2Text: "",
              );
            });
        await Future.delayed(const Duration(seconds: 2)).then((value) {
          closeCustomLoadingDialog(context);
          Navigator.popAndPushNamed(context, RoutesName.siginView);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text(
              AppLocalization.of(context)!.translate('empty-field'),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        closeCustomLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text(
              AppLocalization.of(context)!.translate('password-weak'),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        closeCustomLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text(
              AppLocalization.of(context)!.translate('email-already-exists'),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
        log('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        clearText();
        closeCustomLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          // ignore: prefer_const_constructors
          SnackBar(
            backgroundColor: CustomColor.redColor,
            content: const Text("Invalid email format "),
            duration: const Duration(seconds: 3),
          ),
        );
        log('Wrong password provided for that user.');
      } else {
        clearText();
        closeCustomLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          // ignore: prefer_const_constructors
          SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text(
              AppLocalization.of(context)!.translate('error-somthing'),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      closeCustomLoadingDialog(context);
      log(e.toString());
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    try {
      showCustomLoadingDialog(context);
      await _auth.currentUser?.delete();
      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
      await closeCustomLoadingDialog(context);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              heading: AppLocalization.of(context)!.translate('success'),
              icon: const Icon(Icons.done),
              backgroundColor: CustomColor.primaryColor,
              title: AppLocalization.of(context)!
                  .translate('account-delete-success'),
              descriptions: "", //
              btn1Text: "",
              btn2Text: "",
            );
          });
      await Future.delayed(const Duration(seconds: 2)).then(
          (value) => Navigator.popAndPushNamed(context, RoutesName.siginView));

      notifyListeners();
    } catch (e) {
      closeCustomLoadingDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: CustomColor.redColor,
          content: Text(
            AppLocalization.of(context)!.translate('account-delete-error'),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
      log('Error deleting account: $e');
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _user = null;

    Navigator.popAndPushNamed(context, RoutesName.siginView);

    notifyListeners();
  }
}
