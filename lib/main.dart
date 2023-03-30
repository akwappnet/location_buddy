// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_buddy/localization/app_localization.dart';
import 'package:location_buddy/provider/current_data_provider.dart';
import 'package:location_buddy/provider/forget_password_provider.dart';

import 'package:location_buddy/provider/home_view_provider.dart';
import 'package:location_buddy/provider/live_traking_view_provider.dart';
import 'package:location_buddy/provider/save_location_view_provider.dart';
import 'package:location_buddy/provider/sign_in_provider.dart';
import 'package:location_buddy/utils/routes/routes.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final CurrentData currentData = CurrentData();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SaveLocationViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LiveTrackingViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ForgetPassword(),
        ),
        ChangeNotifierProvider(
          create: (context) => currentData,
        )
      ],
      child: ScreenUtilInit(
          designSize: const Size(430, 932),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return Consumer(
              builder: (context, provider, child) => MaterialApp(
                title: 'Flutter Demo',
                debugShowCheckedModeBanner: false,
                locale: Provider.of<CurrentData>(context).locale,
                localizationsDelegates: const [
                  AppLocalizationDelegate(),
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: [
                  const Locale('en'),
                  const Locale('ar'),
                ],
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                initialRoute: RoutesName.splashView,
                onGenerateRoute: Routes.generateRoute,
              ),
            );
          }),
    );
  }
}
