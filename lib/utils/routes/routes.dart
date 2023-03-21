import 'package:flutter/material.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:location_buddy/view/home_view.dart';
import 'package:location_buddy/view/splash_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homeScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeView());
      case RoutesName.splashView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text('No route defined')),
          );
        });
    }
  }
}
