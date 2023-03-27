import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/provider/sign_in_provider.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/font/font_family.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomColor.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 190.h,
              width: 190.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(auth.currentUser!.photoURL!),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 50.h),
            Center(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 32.sp,
                  ),
                  children: [
                    TextSpan(
                      text: auth.currentUser!.displayName!,
                      style: TextStyle(
                          color: CustomColor.primaryColor,
                          fontWeight: FontWeight.w800,
                          fontFamily: FontFamliyM.ROBOTOBLACK),
                    ),
                    TextSpan(
                      text: auth.currentUser!.email!,
                      style: TextStyle(
                          color: CustomColor.secondaryColor,
                          fontWeight: FontWeight.w800,
                          fontFamily: FontFamliyM.ROBOTOBOLD),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  final provider =
                      Provider.of<SignInProvider>(context, listen: false);
                  provider.signOut(context);
                },
                child: const Text("Logout"))
          ],
        ),
      ),
    );
  }
}
