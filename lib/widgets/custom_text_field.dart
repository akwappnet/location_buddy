// ignore_for_file: must_be_immutable

import 'package:auto_direction/auto_direction.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location_buddy/utils/font/font_family.dart';
import 'package:location_buddy/utils/font/font_style.dart';

class BuildTextFormField extends StatefulWidget {
  final FaIcon? leftIcon;
  final String? txtHint;
  bool isObserve = false;
  bool? readOnly = false;
  final IconButton? icon;
  String? Function(String?)? onChange;
  TextEditingController? controller;
  final VoidCallback? onClicked;
  TextInputType? textType;
  dynamic validation;

  //Text Form Widget
  BuildTextFormField({
    Key? key,
    this.leftIcon,
    this.txtHint,
    required this.isObserve,
    this.icon,
    this.validation,
    this.controller,
    this.onClicked,
    this.onChange,
    this.readOnly,
    this.textType,
  }) : super(key: key);

  @override
  State<BuildTextFormField> createState() => _BuildTextFormFieldState();
}

class _BuildTextFormFieldState extends State<BuildTextFormField> {
  bool isError = true;
  String text = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0.sp),
      child: AutoDirection(
        text: text,
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          keyboardType: widget.textType,
          validator: widget.validation,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTap: widget.onClicked,
          onChanged: widget.onChange,
          readOnly: widget.readOnly ?? false,
          obscureText: widget.isObserve,
          cursorColor: Colors.black,
          controller: widget.controller,
          style: montserratHeadingStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontFamily: FontFamliyM.REGULAR),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
              left: 15.sp,
            ),
            border: InputBorder.none,
            isDense: false,
            labelText: widget.txtHint,
            errorStyle: const TextStyle(color: Colors.black),
            labelStyle: montserratHeadingStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontFamily: FontFamliyM.REGULAR),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.sp),
                borderSide: BorderSide(
                    color: isError ? Colors.black : Colors.black, width: 1.w)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.sp),
                borderSide: BorderSide(color: Colors.black, width: 1.w)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.sp),
                borderSide: BorderSide(color: Colors.black, width: 1.w)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.sp),
                borderSide: BorderSide(color: Colors.black, width: 1.w)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.sp),
                borderSide: BorderSide(color: Colors.black, width: 1.w)),
          ),
        ),
      ),
    );
  }
}
