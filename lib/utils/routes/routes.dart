import 'package:flutter/material.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:location_buddy/view/home_view.dart';
import 'package:location_buddy/view/live_traking_view.dart';
import 'package:location_buddy/view/route_view.dart';
import 'package:location_buddy/view/save_location_view.dart';
import 'package:location_buddy/view/sign_in_view.dart';
import 'package:location_buddy/view/splash_view.dart';
import 'package:location_buddy/widgets/bottom_navigation_bar.dart';

import '../../provider/current_data_provider.dart';
import '../../view/sign_up_view.dart';

class Routes {
  static final isRtl = CurrentData().locale.languageCode == "ar";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homeView:
        return MaterialPageRoute(
            builder: (BuildContext context) => Directionality(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                child: HomeView()));
      case RoutesName.routeView:
        return MaterialPageRoute(
            builder: (BuildContext context) => Directionality(
                textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
                child: const MapScreen()));
      case RoutesName.splashView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());

      case RoutesName.bottomBar:
        return MaterialPageRoute(
            builder: (BuildContext context) => BottomNavBar());
      case RoutesName.saveLocationView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SaveLocationView());
      case RoutesName.livetrakingpage:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LiveTrackingPage());
      case RoutesName.siginview:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignInView());
      case RoutesName.sigupview:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SignUpView());

      default:
        // SystemNavigator.pop();
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text('No route defined')),
          );
        });
    }
  }
}
