import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/utils/assets/assets_utils.dart';
import 'package:location_buddy/view/home_view.dart';

import '../utils/font/font_family.dart';
import '../utils/routes/routes_name.dart';
import '../widgets/custom_text_field_new.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40.h,
                ),
                buildCard(size),
                buildFooter(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      width: size.width * 0.9,
      height: size.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //logo & login text here
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logo(size.height / 8, size.height / 8),
                SizedBox(
                  height: size.height * 0.03,
                ),
                richText(24),
              ],
            ),
          ),

          //email , password textField and rememberForget text here
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BuildTextFormFieldNew(
                  controller: emailController,
                  size: size,
                  isObserve: false,
                  txtHint: "Enter Email",
                  leftIcon: Icon(
                    Icons.email,
                    color: emailController.text.isEmpty
                        ? const Color(0xFF151624).withOpacity(0.5)
                        : const Color.fromRGBO(44, 185, 176, 1),
                    size: 24,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                BuildTextFormFieldNew(
                  controller: passController,
                  size: size,
                  isObserve: true,
                  txtHint: "Enter Password",
                  leftIcon: Icon(
                    Icons.lock,
                    color: passController.text.isEmpty
                        ? const Color(0xFF151624).withOpacity(0.5)
                        : const Color.fromRGBO(44, 185, 176, 1),
                    size: 24,
                  ),
                ),
                //emailTextField(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                BuildTextFormFieldNew(
                  controller: passController,
                  size: size,
                  isObserve: true,
                  txtHint: "Enter Confirm Password",
                  leftIcon: Icon(
                    Icons.lock,
                    color: passController.text.isEmpty
                        ? const Color(0xFF151624).withOpacity(0.5)
                        : const Color.fromRGBO(44, 185, 176, 1),
                    size: 24,
                  ),
                ),
                //emailTextField(size),
                SizedBox(
                  height: size.height * 0.02,
                ),
                signUpButton(size),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget logo(double height_, double width_) {
    return Image.asset(
      AssetsUtils.login,
      height: height_,
      width: width_,
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: FontFamliyM.ROBOTOLIGHT,
          color: const Color(0xFF21899C),
          letterSpacing: 2.000000061035156,
        ),
        children: [
          TextSpan(
            text: 'Registration ',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: FontFamliyM.ROBOTOBOLD),
          ),
          TextSpan(
            text: 'Here',
            style: TextStyle(
                color: const Color(0xFFFE9879),
                fontWeight: FontWeight.w800,
                fontFamily: FontFamliyM.ROBOTOBOLD),
          ),
        ],
      ),
    );
  }

  Widget signUpButton(Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      },
      child: Container(
        alignment: Alignment.center,
        height: size.height / 13,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: const Color(0xFF21899C),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4C2E84).withOpacity(0.2),
              offset: const Offset(0, 15.0),
              blurRadius: 60.0,
            ),
          ],
        ),
        child: Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontFamily: FontFamliyM.ROBOTOBOLD,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildFooter(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.03),
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: 'Already have an account ? ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: FontFamliyM.ROBOTOBOLD,
              ),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushReplacementNamed(context, RoutesName.siginview);
                },
              text: 'Sign In here',
              style: TextStyle(
                color: const Color(0xFFFF7248),
                fontWeight: FontWeight.w500,
                fontFamily: FontFamliyM.ROBOTOBOLD,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
