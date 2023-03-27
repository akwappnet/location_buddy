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
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

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
      mainAxisAlignment: MainAxisAlignment.center,
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
            width: size.width / 2.8,
            height: size.height / 13,
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

        //facebook button
        GestureDetector(
          onTap: () {
            /*  final provider =
                Provider.of<SignInProvider>(context, listen: false);
            provider.signOut(); */
          },
          child: Container(
            alignment: Alignment.center,
            width: size.width / 2.8,
            height: size.height / 13,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                width: 1.0,
                color: CustomColor.black,
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
                    // Vector
                    '<svg viewBox="13.0 11.0 18.62 22.92" ><path transform="translate(13.0, 11.0)" d="M 13.86734199523926 0.01146837882697582 C 13.81864452362061 -0.04295870289206505 12.0640869140625 0.03295278549194336 10.53726387023926 1.690114140510559 C 9.010440826416016 3.345843315124512 9.245336532592773 5.245062351226807 9.279711723327637 5.293760299682617 C 9.3140869140625 5.34245777130127 11.45679569244385 5.418369293212891 12.82463455200195 3.491936922073364 C 14.19247245788574 1.565504670143127 13.91604042053223 0.06732775270938873 13.86734199523926 0.01146837882697582 L 13.86734199523926 0.01146837882697582 Z M 18.61395645141602 16.8165454864502 C 18.54520606994629 16.67904663085938 15.28387928009033 15.04909896850586 15.5875244140625 11.91524410247803 C 15.89117050170898 8.77995777130127 17.98661231994629 7.920583248138428 18.01955604553223 7.827484607696533 C 18.05249786376953 7.73438549041748 17.16447639465332 6.695973873138428 16.22346115112305 6.170322895050049 C 15.53254699707031 5.799720764160156 14.76786804199219 5.587391376495361 13.98478984832764 5.548707962036133 C 13.83010196685791 5.544411182403564 13.29299354553223 5.41264009475708 12.18869590759277 5.714853763580322 C 11.46109199523926 5.913942337036133 9.821117401123047 6.558474063873291 9.369945526123047 6.584255218505859 C 8.917341232299805 6.610036373138428 7.570987701416016 5.83659839630127 6.122940540313721 5.631780624389648 C 5.196248054504395 5.452744007110596 4.213696002960205 5.819411754608154 3.510440826416016 6.10157299041748 C 2.808617830276489 6.382302284240723 1.473721981048584 7.181520938873291 0.5398677587509155 9.305609703063965 C -0.3939864635467529 11.42826557159424 0.09442496299743652 14.79128551483154 0.4439041316509247 15.83685874938965 C 0.7933833003044128 16.8809986114502 1.339086413383484 18.59258651733398 2.267211437225342 19.84154510498047 C 3.092211484909058 21.25092124938965 4.186482429504395 22.22917556762695 4.643383502960205 22.56146812438965 C 5.100284576416016 22.89375877380371 6.389346599578857 23.11433219909668 7.283096790313721 22.65743255615234 C 8.002107620239258 22.21628570556641 9.299763679504395 21.96277046203613 9.81252384185791 21.98138999938965 C 10.32385158538818 22.00000953674316 11.33218574523926 22.20196151733398 12.3648681640625 22.75339508056641 C 13.18270683288574 23.03555679321289 13.95614337921143 22.9181079864502 14.73101329803467 22.60300445556641 C 15.50588321685791 22.28646850585938 16.62736701965332 21.08620643615723 17.93648147583008 18.65274429321289 C 18.43348693847656 17.52123260498047 18.6597900390625 16.90964508056641 18.61395645141602 16.8165454864502 L 18.61395645141602 16.8165454864502 Z" fill="#000000" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    width: 18.62,
                    height: 22.92,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  'Apple',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: CustomColor.black,
                    fontFamily: FontFamliyM.ROBOTOBOLD,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
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
