import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/data/default_data.dart';
import 'package:location_buddy/provider/current_data_provider.dart';
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

  final DefaultData defaultData = DefaultData();

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
            Consumer<CurrentData>(builder: (context, currentData, child) {
              return DropdownButton<String>(
                value: currentData.defineCurrentLanguage(context),
                icon: const Icon(
                  Icons.arrow_downward,
                  color: Colors.red,
                ),
                iconSize: 20,
                elevation: 0,
                style: const TextStyle(color: Colors.red),
                underline: Container(
                  height: 1,
                ),
                dropdownColor: CustomColor.Violet,
                onChanged: (String? newValue) {
                  currentData.changeLocale(newValue!);
                },
                items: defaultData.languagesListDefault
                    .map<DropdownMenuItem<String>>(
                  (String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  },
                ).toList(),
              );
            }),
            Container(
              height: 190.h,
              width: 190.w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(auth.currentUser?.photoURL ??
                      "https://cdn-icons-png.flaticon.com/128/3177/3177440.png"),
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
                      text: auth.currentUser?.displayName ?? "No Name",
                      style: TextStyle(
                          color: CustomColor.primaryColor,
                          fontWeight: FontWeight.w800,
                          fontFamily: FontFamliyM.ROBOTOBLACK),
                    ),
                    TextSpan(
                      text: auth.currentUser?.email ?? "demo email",
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
