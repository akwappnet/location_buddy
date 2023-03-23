import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/utils/colors/colors.dart';

import '../utils/font/font_family.dart';
import '../utils/font/font_style.dart';

class CustomDialogBox extends StatefulWidget {
  final String? heading, title, descriptions, btn1Text, btn2Text;
  final Image? img;
  final Color? backgroundColor;
  final Icon? icon;
  final VoidCallback? onClicked;

  const CustomDialogBox(
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
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
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
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: 20.sp, top: 65.sp, right: 20.sp, bottom: 20.sp),
          margin: EdgeInsets.only(top: 45.sp),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(15.sp),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.heading ?? "",
                style: const TextStyle(color: CustomColor.black),
                /*  style: openSansHeadingStyle(
                    color: PrimaryColor.blackColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamliy.OPEN_SANS_SEMI_BOLD), */
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 7.h,
              ),
              Text(
                widget.title ?? "",
                style: montserratHeadingStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamliyM.REGULAR),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 7.h,
              ),
              Text(
                widget.descriptions!,
                style: montserratHeadingStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: FontFamliyM.REGULAR),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 7.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.btn1Text == ""
                      ? const SizedBox()
                      : SizedBox(
                          height: 40.h,
                          width: 130.w,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.onClicked!();
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.sp)),
                                backgroundColor: widget.backgroundColor ??
                                    CustomColor.redColor),
                            child: Text(
                              widget.btn1Text!,
                              style: montserratHeadingStyle(
                                  color: CustomColor.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: FontFamliyM.REGULAR),
                            ),
                          ),
                        ),
                  SizedBox(
                    width: 10.w,
                  ),
                  widget.btn2Text == ""
                      ? const SizedBox()
                      : SizedBox(
                          height: 40.h,
                          width: 130.w,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.sp)),
                                backgroundColor: SecondaryColor.greyColor),
                            child: Text(
                              widget.btn2Text!,
                              style: montserratHeadingStyle(
                                  color: CustomColor.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: FontFamliyM.REGULAR),
                            ),
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          left: 20.sp,
          right: 20.sp,
          child: CircleAvatar(
            backgroundColor: SecondaryColor.whiteColor,
            radius: 50.sp,
            child: CircleAvatar(
              backgroundColor: widget.backgroundColor ?? CustomColor.redColor,
              radius: 45.sp,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: widget.icon ??
                    Icon(
                      Icons.delete_forever_rounded,
                      size: 50.sp,
                    ),
                color: SecondaryColor.whiteColor,
                onPressed: () {},
              ),
            ),
          ),
        )
      ],
    );
  }
}
