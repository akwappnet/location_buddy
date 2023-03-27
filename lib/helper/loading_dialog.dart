import 'package:flutter/cupertino.dart';
import 'package:location_buddy/utils/colors/colors.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

//show loading dialog when data processing
void showCustomLoadingDialog(BuildContext context) async {
  SimpleFontelicoProgressDialog dialog =
      SimpleFontelicoProgressDialog(context: context);
  dialog.show(
      backgroundColor: CustomColor.white,
      indicatorColor: CustomColor.primaryColor,
      message: 'Please Wait...',
      radius: 10,
      type: SimpleFontelicoProgressDialogType.hurricane);
}

//hide loading dialog when data processing
Future<void> closeCustomLoadingDialog(BuildContext context) async {
  SimpleFontelicoProgressDialog dialog =
      SimpleFontelicoProgressDialog(context: context);
  dialog.hide();
}
