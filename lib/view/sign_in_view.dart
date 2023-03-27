import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location_buddy/utils/assets/assets_utils.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:location_buddy/view/home_view.dart';
import 'package:provider/provider.dart';

import '../provider/sign_in_provider.dart';
import '../utils/font/font_family.dart';
import '../utils/routes/routes_name.dart';
import '../widgets/custom_dialog_box.dart';
import '../widgets/custom_text_field_new.dart';

class SignInView extends StatefulWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                heading: "Exit App",
                icon: const Icon(Icons.exit_to_app),
                backgroundColor: CustomColor.primaryColor,
                title: "Are you sure you want to exit app ?",
                descriptions: "", //
                btn1Text: "Exit",
                btn2Text: "Cancel",
                onClicked: () {
                  SystemNavigator.pop();
                },
              );
            });
        return Future.value(true);
      },
      child: Scaffold(
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
      ),
    );
  }

  Widget buildCard(Size size) {
    final provider = Provider.of<SignInProvider>(context, listen: false);
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
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BuildTextFormFieldNew(
                  controller: provider.emailController,
                  size: size,
                  isObserve: false,
                  txtHint: "Enter Email",
                  leftIcon: Icon(
                    Icons.email,
                    color: provider.emailController.text.isEmpty
                        ? const Color(0xFF151624).withOpacity(0.5)
                        : const Color.fromRGBO(44, 185, 176, 1),
                    size: 24,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                BuildTextFormFieldNew(
                  controller: provider.passController,
                  size: size,
                  isObserve: true,
                  txtHint: "Enter Password",
                  leftIcon: Icon(
                    Icons.lock,
                    color: provider.passController.text.isEmpty
                        ? const Color(0xFF151624).withOpacity(0.5)
                        : const Color.fromRGBO(44, 185, 176, 1),
                    size: 24,
                  ),
                ),
                //emailTextField(size),
                SizedBox(
                  height: size.height * 0.01,
                ),

                //remember & forget text
                buildRemember_ForgetSection(size),
              ],
            ),
          ),

          //sign in button, 'don't have account' text and social button here
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //sign in button here
                signInButton(size),
                SizedBox(
                  height: size.height * 0.02,
                ),

                //don't have account text here
                buildNoAccountText(),
                SizedBox(
                  height: size.height * 0.02,
                ),

                //sign in with google & facebook button here
                google_facebookButton(size),
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
            text: 'Welcome ',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: FontFamliyM.ROBOTOBOLD),
          ),
          TextSpan(
            text: 'Back',
            style: TextStyle(
                color: const Color(0xFFFE9879),
                fontWeight: FontWeight.w800,
                fontFamily: FontFamliyM.ROBOTOBOLD),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget buildRemember_ForgetSection(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Spacer(),
          Text(
            'Forgot password?',
            style: TextStyle(
                fontSize: 16.sp,
                color: const Color(0xFF21899C),
                fontWeight: FontWeight.w500,
                fontFamily: FontFamliyM.ROBOTOBOLD),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget signInButton(Size size) {
    return GestureDetector(
      onTap: () {
        final provider = Provider.of<SignInProvider>(context, listen: false);
        provider.signInWithEmailAndPassword(provider.emailController.text,
            provider.passController.text, context);
      },
      child: Container(
        alignment: Alignment.center,
        height: size.height / 14,
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
          'Sign in',
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

  Widget buildNoAccountText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      // ignore: prefer_const_literals_to_create_immutables
      children: <Widget>[
        const Expanded(
            flex: 4,
            child: Divider(
              color: Color(0xFF969AA8),
            )),
        Expanded(
          flex: 3,
          child: Text(
            'Continue ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.0,
              color: const Color(0xFF969AA8),
              fontWeight: FontWeight.w500,
              fontFamily: FontFamliyM.ROBOTOBOLD,
              height: 1.67,
            ),
          ),
        ),
        const Expanded(
            flex: 4,
            child: Divider(
              color: Color(0xFF969AA8),
            )),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Widget google_facebookButton(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        //google button
        GestureDetector(
          onTap: () {
            final provider =
                Provider.of<SignInProvider>(context, listen: false);
            provider.signInWithGoogle(context);
          },
          child: Container(
            alignment: Alignment.center,
            width: size.width / 1.3,
            height: size.height / 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                width: 1.0,
                color: const Color(0xFF4285F4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 24.0,
                  height: 24.0,
                  color: const Color(0xFFC4C4C4).withOpacity(0.0),
                  child: SvgPicture.string(
                    // Group 59
                    '<svg viewBox="1.0 0.0 22.92 22.92" ><path transform="translate(1.0, 0.0)" d="M 22.6936149597168 9.214142799377441 L 21.77065277099609 9.214142799377441 L 21.77065277099609 9.166590690612793 L 11.45823860168457 9.166590690612793 L 11.45823860168457 13.74988651275635 L 17.93386268615723 13.74988651275635 C 16.98913192749023 16.41793632507324 14.45055770874023 18.33318138122559 11.45823860168457 18.33318138122559 C 7.661551475524902 18.33318138122559 4.583295345306396 15.25492572784424 4.583295345306396 11.45823860168457 C 4.583295345306396 7.661551475524902 7.661551475524902 4.583295345306396 11.45823860168457 4.583295345306396 C 13.21077632904053 4.583295345306396 14.80519008636475 5.244435787200928 16.01918983459473 6.324374675750732 L 19.26015281677246 3.083411931991577 C 17.21371269226074 1.176188230514526 14.47633838653564 0 11.45823860168457 0 C 5.130426406860352 0 0 5.130426406860352 0 11.45823860168457 C 0 17.78605079650879 5.130426406860352 22.91647720336914 11.45823860168457 22.91647720336914 C 17.78605079650879 22.91647720336914 22.91647720336914 17.78605079650879 22.91647720336914 11.45823860168457 C 22.91647720336914 10.68996334075928 22.83741569519043 9.940022468566895 22.6936149597168 9.214142799377441 Z" fill="#ffc107" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(2.32, 0.0)" d="M 0 6.125000953674316 L 3.764603137969971 8.885863304138184 C 4.78324031829834 6.363905429840088 7.250198841094971 4.583294868469238 10.13710117340088 4.583294868469238 C 11.88963890075684 4.583294868469238 13.48405265808105 5.244434833526611 14.69805240631104 6.324373722076416 L 17.93901443481445 3.083411693572998 C 15.89257335662842 1.176188111305237 13.15520095825195 0 10.13710117340088 0 C 5.735992908477783 0 1.919254422187805 2.484718799591064 0 6.125000953674316 Z" fill="#ff3d00" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(2.26, 13.78)" d="M 10.20069408416748 9.135653495788574 C 13.16035556793213 9.135653495788574 15.8496036529541 8.003005981445312 17.88286781311035 6.161093711853027 L 14.33654403686523 3.160181760787964 C 13.14749050140381 4.064460277557373 11.69453620910645 4.553541660308838 10.20069408416748 4.55235767364502 C 7.220407009124756 4.55235767364502 4.689855575561523 2.6520094871521 3.736530303955078 0 L 0 2.878881216049194 C 1.896337866783142 6.589632034301758 5.747450828552246 9.135653495788574 10.20069408416748 9.135653495788574 Z" fill="#4caf50" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(12.46, 9.17)" d="M 11.23537635803223 0.04755179211497307 L 10.31241607666016 0.04755179211497307 L 10.31241607666016 0 L 0 0 L 0 4.583295345306396 L 6.475625038146973 4.583295345306396 C 6.023715496063232 5.853105068206787 5.209692478179932 6.962699413299561 4.134132385253906 7.774986743927002 L 4.135851383209229 7.773841857910156 L 7.682177066802979 10.77475357055664 C 7.431241512298584 11.00277233123779 11.45823955535889 8.020766258239746 11.45823955535889 2.291647672653198 C 11.45823955535889 1.523372769355774 11.37917804718018 0.773431122303009 11.23537635803223 0.04755179211497307 Z" fill="#1976d2" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 22.92,
                    height: 22.92,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  'Google',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: FontFamliyM.ROBOTOBOLD,
                    color: const Color(0xFF4285F4),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 16),
      ],
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
              text: 'Don’t have an account ? ',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontFamily: FontFamliyM.ROBOTOBOLD,
              ),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, RoutesName.sigupview);
                },
              text: 'Sign Up here',
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
