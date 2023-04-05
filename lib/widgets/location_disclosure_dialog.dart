import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:lottie/lottie.dart';

import '../utils/assets/assets_utils.dart';
import '../utils/font/font_family.dart';
import '../utils/font/font_style.dart';

class LocationDisclosureDialog extends StatefulWidget {
  final String? heading, title, descriptions, btn1Text, btn2Text;
  final Image? img;
  final Color? backgroundColor;
  final Icon? icon;
  final VoidCallback? onClicked;

  const LocationDisclosureDialog(
      {Key? key,
      this.title,
      this.descriptions,
      this.heading,
      this.btn1Text,
      this.btn2Text,
      this.img,
      this.icon,
      this.onClicked,
      this.backgroundColor})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LocationDisclosureDialogState createState() =>
      _LocationDisclosureDialogState();
}

class _LocationDisclosureDialogState extends State<LocationDisclosureDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.sp),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      padding: EdgeInsets.only(left: 20.sp, right: 20.sp, bottom: 20.sp),
      // margin: EdgeInsets.only(top: 45.sp)
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: CustomColor.white,
        borderRadius: BorderRadius.circular(15.sp),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: Image.asset(
              AssetsUtils.locationrequest,
              height: 250.h,
              width: 200.w,
            ),
          ),
          Text(
            widget.heading ?? "",
            style: TextStyle(
                color: CustomColor.black,
                fontSize: 22.sp,
                //fontWeight: FontWeight.w500,
                fontFamily: FontFamliyM.ROBOTOBLACK),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.sp),
            child: Text(
              widget.descriptions!,
              style: TextStyle(
                  color: CustomColor.black,
                  fontSize: 16.sp,
                  //  fontWeight: FontWeight.w900,
                  fontFamily: FontFamliyM.ROBOTOREGULAR),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            height: 50.h,

            width: MediaQuery.of(context).size.width,
            //width: 170.w,
            child: ElevatedButton(
              onPressed: () {
                widget.onClicked!();
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.sp)),
                  backgroundColor:
                      widget.backgroundColor ?? CustomColor.redColor),
              child: Text(
                widget.btn1Text!,
                style: TextStyle(
                    color: CustomColor.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    fontFamily: FontFamliyM.ROBOTOREGULAR),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              "Not now",
              style: TextStyle(
                  color: CustomColor.secondaryColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: FontFamliyM.ROBOTOLIGHT),
            ),
          )
        ],
      ),
    );
  }
}
