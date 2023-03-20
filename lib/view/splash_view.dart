import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    //final remoteConfig = Provider.of<RemoteConfig>(context, listen: false);

    return Scaffold(
      body: FutureBuilder<void>(
        //   future: remoteConfig.fetchAndActivate(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            //final splashText = remoteConfig.getString('splash_text');
            //final splashLogoUrl = remoteConfig.getString('splash_logo_url');

            return Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    "splashLogoUrl",
                    height: 150,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "splashText",
                    style: TextStyle(
                      fontSize: 24.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
