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

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  SignInProvider() {
    _checkCurrentUser();
  }

  User? get user => _user;

  Future<void> _checkCurrentUser() async {
    _user = _auth.currentUser;
    notifyListeners();
  }

  void clearText() {
    emailController.clear();
    passController.clear();
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
          clearText();
          Navigator.popAndPushNamed(context, RoutesName.bottomBar);
        });

        // ignore: use_build_conte
      } else {
        // ignore: use_build_context_synchronously
        clearText();
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
      clearText();

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
                heading: "Success",
                icon: const Icon(Icons.done),
                backgroundColor: CustomColor.primaryColor,
                title: "Login Successfull",
                descriptions: "", //
                btn1Text: "",
                btn2Text: "",
              );
            });
        // ignore: use_build_context_synchronously

        await Future.delayed(const Duration(seconds: 2)).then((value) {
          clearText();
          closeCustomLoadingDialog(context);
          Navigator.popAndPushNamed(context, RoutesName.bottomBar);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text('Please fill all fields...'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        clearText();
        closeCustomLoadingDialog(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text('No user found for that email.'),
            duration: Duration(seconds: 3),
          ),
        );
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        clearText();
        closeCustomLoadingDialog(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text('Wrong password...'),
            duration: Duration(seconds: 3),
          ),
        );
        log('Wrong password provided for that user.');
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
        // ignore: use_build_context_synchronously
        await Future.delayed(const Duration(seconds: 2)).then((value) {
          closeCustomLoadingDialog(context);
          Navigator.popAndPushNamed(context, RoutesName.siginView);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text('Please fill all fields...'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        closeCustomLoadingDialog(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text('The password provided is too weak.'),
            duration: Duration(seconds: 3),
          ),
        );
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        closeCustomLoadingDialog(context);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: CustomColor.redColor,
            content: Text('The account already exists for that email.'),
            duration: Duration(seconds: 3),
          ),
        );
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
    Navigator.popAndPushNamed(context, RoutesName.siginView);
    notifyListeners();
  }
}
