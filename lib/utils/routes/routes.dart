import 'package:flutter/material.dart';
import 'package:location_buddy/utils/routes/routes_name.dart';
import 'package:location_buddy/view/home_view.dart';
import 'package:location_buddy/view/route_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homeScreen:
        return MaterialPageRoute(builder: (BuildContext context) => HomeView());
      case RoutesName.routeScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => RouteView());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(child: Text('No route defined')),
          );
        });
    }
  }
}
