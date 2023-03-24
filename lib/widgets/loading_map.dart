import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../utils/assets/assets_utils.dart';

class Maploading extends StatelessWidget {
  const Maploading({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(AssetsUtils.loadingmap,
        height: 250.h, width: 250.w, animate: true);
  }
}
