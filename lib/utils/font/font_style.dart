import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/font/font_family.dart';

TextStyle? montserratHeadingStyle(
    {Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? fontSize}) {
  return TextStyle(
      fontSize: fontSize ?? 12.sp,
      overflow: TextOverflow.visible,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? Colors.white,
      fontFamily: fontFamily ?? FontFamliyM.SEMIBOLD);
}

TextStyle montserratHeading4tyle = TextStyle(
    fontSize: 16.sp,
    color: SecondaryColor.greyColor,
    fontFamily: FontFamliyM.SEMIBOLD,
    fontWeight: FontWeight.w600);
TextStyle? poppinsHeadingStyle(
    {Color? color,
    FontWeight? fontWeight,
    String? fontFamily,
    double? fontSize}) {
  return TextStyle(
      overflow: TextOverflow.ellipsis,
      fontSize: fontSize ?? 12.sp,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color ?? Colors.white,
      fontFamily: fontFamily ?? FontFamliyM.REGULAR);
}
