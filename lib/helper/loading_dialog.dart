import 'package:flutter/cupertino.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../localization/app_localization.dart';

//show loading dialog when data processing
void showCustomLoadingDialog(BuildContext context) async {
  SimpleFontelicoProgressDialog dialog =
      SimpleFontelicoProgressDialog(context: context);
  dialog.show(
      backgroundColor: CustomColor.white,
      indicatorColor: CustomColor.primaryColor,
      message: AppLocalization.of(context)!.translate('save-button2'),
      radius: 10,
      type: SimpleFontelicoProgressDialogType.hurricane);
}

//hide loading dialog when data processing
Future<void> closeCustomLoadingDialog(BuildContext context) async {
  SimpleFontelicoProgressDialog dialog =
      SimpleFontelicoProgressDialog(context: context);
  Navigator.pop(context);
  dialog.hide();
}
