// ignore_for_file: must_be_immutable, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/provider/forget_password_provider.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/utils/font/font_family.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:location_buddy/utils/validation/validation.dart';
import 'package:location_buddy/widgets/custom_button_widget.dart';
import 'package:location_buddy/widgets/custom_text_field_auth.dart';
import 'package:provider/provider.dart';

import '../localization/app_localization.dart';

class ForgetPasswordView extends StatelessWidget {
  //Intialize Controller
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ForgetPassword>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: CustomColor.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesName.siginView);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: CustomColor.black,
              )),
          title: Text(
            AppLocalization.of(context)!.translate('forgot-password-1'),
            style: TextStyle(
                color: CustomColor.black,
                fontSize: 20.sp,
                fontFamily: FontFamliyM.ROBOTOREGULAR,
                fontWeight: FontWeight.w700),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.sp),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Text(
                  AppLocalization.of(context)!.translate('forgot-password'),
                  style: TextStyle(
                      color: CustomColor.secondaryColor,
                      fontFamily: FontFamliyM.ROBOTOREGULAR,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(AppLocalization.of(context)!.translate('fogot-desc'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: CustomColor.black,
                        fontFamily: FontFamliyM.SEMIBOLD,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10.h,
                ),
                Form(
                  key: _formKey,
                  child: BuildTextFormFieldNew(
                    controller: emailController,
                    validation: emailValidator,
                    isObserve: false,
                    txtHint: AppLocalization.of(context)!
                        .translate('txt-email-hint'),
                    leftIcon: Icon(
                      Icons.email,
                      color: emailController.text.isEmpty
                          ? const Color(0xFF151624).withOpacity(0.5)
                          : const Color.fromRGBO(44, 185, 176, 1),
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.sp,
                ),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        provider
                            .resetPassword(emailController.text, context)
                            .then((_) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(AppLocalization.of(context)!
                                    .translate('email-sent'))),
                          );
                          Navigator.pop(context);
                        }).catchError((e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        });
                      }
                    },
                    child: AppButton(
                      mycolor: CustomColor.primaryColor,
                      text: AppLocalization.of(context)!.translate('continue'),
                      height: 54.h,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
