// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:location_buddy/utils/font/font_family.dart';

class BuildTextFormFieldNew extends StatefulWidget {
  final Icon? leftIcon;
  final Size size;
  final String? txtHint;
  bool isObserve = false;
  bool? readOnly = false;
  final IconButton? icon;
  String? Function(String?)? onChange;
  TextEditingController controller;
  final VoidCallback? onClicked;
  TextInputType? textType;
  dynamic validation;
  Icon? suffixIcon;

  //Text Form Widget
  BuildTextFormFieldNew({
    Key? key,
    this.leftIcon,
    this.txtHint,
    required this.isObserve,
    this.icon,
    required this.controller,
    this.onClicked,
    this.onChange,
    this.readOnly,
    this.textType,
    this.validation,
    required this.size,
  }) : super(key: key);

  @override
  State<BuildTextFormFieldNew> createState() => _BuildTextFormFieldNewState();
}

class _BuildTextFormFieldNewState extends State<BuildTextFormFieldNew> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size.height / 12,
      child: TextFormField(
        validator: widget.validation,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: widget.controller,
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: FontFamliyM.ROBOTOREGULAR,
          color: const Color(0xFF151624),
        ),
        maxLines: 1,
        obscureText: widget.isObserve,
        keyboardType: widget.textType ?? TextInputType.name,
        cursorColor: const Color(0xFF151624),
        decoration: InputDecoration(
          hintText: widget.txtHint,
          hintStyle: TextStyle(
            fontSize: 16.0,
            fontFamily: FontFamliyM.ROBOTOREGULAR,
            color: const Color(0xFF151624).withOpacity(0.5),
          ),
          fillColor: widget.controller.text.isNotEmpty
              ? Colors.transparent
              : const Color.fromRGBO(248, 247, 251, 1),
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: BorderSide(
                color: widget.controller.text.isEmpty
                    ? Colors.transparent
                    : const Color(0xFF2CB9B0),
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(
                color: Color.fromRGBO(44, 185, 176, 1),
              )),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(
                color: Color.fromRGBO(176, 11, 36, 1),
              )),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40),
              borderSide: const BorderSide(
                color: Color.fromRGBO(176, 11, 36, 1),
              )),
          prefixIcon: widget.leftIcon,
          suffix: widget.suffixIcon,
        ),
      ),
    );
  }
}
