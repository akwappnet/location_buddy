// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:location_buddy/helper/loading_dialog.dart';

class ForgetPassword with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      showCustomLoadingDialog(context);

      await _auth.sendPasswordResetEmail(email: email);
      closeCustomLoadingDialog(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        closeCustomLoadingDialog(context);
        throw 'Invalid email address';
      } else if (e.code == 'user-not-found') {
        closeCustomLoadingDialog(context);
        throw 'User with this email address does not exist';
      } else {
        closeCustomLoadingDialog(context);
        throw 'Error sending password reset email';
      }
    } catch (e) {
      closeCustomLoadingDialog(context);
      throw 'Unexpected error occurred';
    }
  }
}
