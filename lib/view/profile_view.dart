import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/data/default_data.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/font/font_family.dart';
import 'package:provider/provider.dart';
import '../provider/current_data_provider.dart';
import '../provider/sign_in_provider.dart';
import '../widgets/custom_dialog_box.dart';

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

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
              height: 170.h,
              // margin: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: CustomColor.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0.sp),
                  bottomRight: Radius.circular(50.0.sp),
                ),
                border: Border.all(
                  color: Colors.white,
                  width: 1.0,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50.sp,
                        backgroundColor: SecondaryColor.whiteColor,
                        child: Padding(
                          padding: EdgeInsets.all(5.sp), // Border radius
                          child: ClipOval(
                            child: Image.network(auth.currentUser?.photoURL ??
                                "https://cdn-icons-png.flaticon.com/512/3899/3899618.png"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome ,",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamliyM.ROBOTOBOLD,
                              ),
                            ),
                            Text(auth.currentUser?.email ?? "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                    fontFamily: FontFamliyM.ROBOTOBOLD,
                                    fontWeight: FontWeight.w600))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          Padding(
            padding: EdgeInsets.only(left: 22.sp, top: 22.sp),
            child: Text("App Setting",
                style: TextStyle(
                    color: CustomColor.black,
                    fontSize: 20.sp,
                    fontFamily: FontFamliyM.ROBOTOREGULAR,
                    fontWeight: FontWeight.w700)),
          ),
          SettingsItem(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Column(
                      children: [
                        Row(
                          children: [
                            Text("Select Language",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                    fontFamily: FontFamliyM.ROBOTOBOLD,
                                    fontWeight: FontWeight.w600)),
                            const Spacer(),
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.clear))
                          ],
                        ),
                        Consumer<CurrentData>(
                            builder: (context, currentData, child) {
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
                      ],
                    ),
                  );
                },
              );
            },
            trailing: Icon(Icons.arrow_forward_ios_rounded,
                color: SecondaryColor.greyIconColor),
            icons: Icons.language,
            iconStyle: IconStyle(
              iconsColor: SecondaryColor.greyIconColor,
              backgroundColor: CustomColor.white,
            ),
            title: 'Language',
            titleStyle: TextStyle(
                color: CustomColor.black,
                fontSize: 20.sp,
                fontFamily: FontFamliyM.ROBOTOBOLD,
                fontWeight: FontWeight.w600),
            subtitle: "Select language formate",
          ),
          SettingsItem(
            trailing: Icon(Icons.arrow_forward_ios_rounded,
                color: SecondaryColor.greyIconColor),
            onTap: () {
              showCustomDialog("Privacy", context);
            },
            icons: Icons.lock_open_sharp,
            iconStyle: IconStyle(
              iconsColor: SecondaryColor.greyIconColor,
              backgroundColor: CustomColor.white,
            ),
            title: 'Privacy',
            titleStyle: TextStyle(
                color: CustomColor.black,
                fontSize: 20.sp,
                fontFamily: FontFamliyM.ROBOTOBOLD,
                fontWeight: FontWeight.w600),
            subtitle: "Location Buddy privacy",
          ),
          SettingsItem(
            onTap: () {
              showCustomDialog("About", context);
            },
            icons: Icons.info_outline,
            iconStyle: IconStyle(
              iconsColor: SecondaryColor.greyIconColor,
              backgroundColor: CustomColor.white,
            ),
            title: 'About',
            trailing: Icon(Icons.arrow_forward_ios_rounded,
                color: SecondaryColor.greyIconColor),
            titleStyle: TextStyle(
                color: CustomColor.black,
                fontSize: 20.sp,
                fontFamily: FontFamliyM.ROBOTOBOLD,
                fontWeight: FontWeight.w600),
            subtitle: "Learn more about location buddy",
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.sp),
            child: Text("Account",
                style: TextStyle(
                    color: CustomColor.black,
                    fontSize: 20.sp,
                    fontFamily: FontFamliyM.ROBOTOREGULAR,
                    fontWeight: FontWeight.w700)),
          ),
          SettingsItem(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                        heading: "Logout",
                        title: "Are you sure you want to logout ?",
                        descriptions: "",
                        btn1Text: "Logout",
                        icon: const Icon(Icons.login_outlined),
                        btn2Text: "Cancel",
                        onClicked: () {
                          final provider = Provider.of<SignInProvider>(context,
                              listen: false);
                          provider.signOut(context);
                        });
                  });
            },
            icons: Icons.lock_outline,
            title: "Logout",
            subtitle: "I want to logout from app",
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: CustomColor.primaryColor),
            titleStyle: TextStyle(
                color: CustomColor.primaryColor,
                fontSize: 20.sp,
                fontFamily: FontFamliyM.ROBOTOBOLD,
                fontWeight: FontWeight.w600),
            iconStyle: IconStyle(
              iconsColor: CustomColor.primaryColor,
              backgroundColor: CustomColor.white,
            ),
          ),
          SettingsItem(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialogBox(
                        heading: "Delete",
                        title: "Are you sure you want to delete your account ?",
                        descriptions: "",
                        btn1Text: "Delete",
                        icon: const Icon(Icons.delete_outline),
                        btn2Text: "Cancel",
                        onClicked: () {
                          final provider = Provider.of<SignInProvider>(context,
                              listen: false);
                          provider.deleteAccount(context);
                        });
                  });
            },
            icons: Icons.delete_outline_outlined,
            title: "Delete account",
            subtitle: "I want to delete account",
            trailing: const Icon(Icons.arrow_forward_ios_rounded,
                color: CustomColor.redColor),
            titleStyle: TextStyle(
                color: CustomColor.redColor,
                fontSize: 20.sp,
                fontFamily: FontFamliyM.ROBOTOBOLD,
                fontWeight: FontWeight.w600),
            iconStyle: IconStyle(
              iconsColor: CustomColor.redColor,
              backgroundColor: CustomColor.white,
            ),
          ),
        ],
      ),
    );
  }

/*   @override
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
  } */
}

void showCustomDialog(String title, BuildContext context) => showDialog(
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Row(
                  children: [
                    Text(
                      title,
                      /*   style: openSansHeadingStyle(
                          color: PrimaryColor.blackColor,
                          fontFamily: FontFamliy.OPEN_SANS,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700), */
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.clear))
                  ],
                ),
              ),
              const Divider(height: 1, color: SecondaryColor.greyColor),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text("Welcome : ",
                        style: TextStyle(
                            color: CustomColor.black,
                            fontSize: 18.sp,
                            fontFamily: FontFamliyM.ROBOTOBOLD,
                            fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                        "             Welcome to our location buddy app, designed to help parents and doctors keep track of children's vaccination records. Our app features two separate apps, one for parents and another for doctors, to facilitate communication and collaboration.",
                        style: TextStyle(
                          color: CustomColor.black,
                          fontSize: 16.sp,
                          fontFamily: FontFamliyM.ROBOTOREGULAR,
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text("For User : ",
                        style: TextStyle(
                            color: CustomColor.black,
                            fontSize: 18.sp,
                            fontFamily: FontFamliyM.ROBOTOBOLD,
                            fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                        "             Our app allows parents to easily add their children and keep track of their vaccination records. You can view upcoming vaccine schedules, receive reminders when vaccines are due, and check the history of past vaccines. Our user-friendly interface makes it easy for parents to manage their children's vaccination records, ensuring that they stay up-to-date with the latest vaccinations.",
                        style: TextStyle(
                          color: CustomColor.black,
                          fontSize: 16.sp,
                          fontFamily: FontFamliyM.ROBOTOREGULAR,
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text("For Admin : ",
                        style: TextStyle(
                            color: CustomColor.black,
                            fontSize: 18.sp,
                            fontFamily: FontFamliyM.ROBOTOBOLD,
                            fontWeight: FontWeight.w700)),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                        "             Doctors can connect with children by sending a request to add them to their vaccine schedule. Once connected, doctors can view and modify the child s vaccination record, ensuring that their vaccines are administered on schedule. Our app makes it easy for doctors to keep track of their patients vaccination records, while also providing a secure and reliable platform for communication with parents.",
                        style: TextStyle(
                          color: CustomColor.black,
                          fontSize: 16.sp,
                          fontFamily: FontFamliyM.ROBOTOREGULAR,
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      context: context,
      barrierDismissible: false,
    );
