import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:location_buddy/view/home_view.dart';
import 'package:location_buddy/view/splash_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homeView:
        return MaterialPageRoute(builder: (BuildContext context) => HomeView());
      case RoutesName.routeView:
        return MaterialPageRoute(builder: (BuildContext context) => HomeView());
      case RoutesName.splashView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());

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
