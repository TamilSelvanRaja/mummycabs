import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/custom_popup.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';

class Utils {
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();
  bool isNumberValid(value) {
    return RegExp(r'^[6789]\d{9}$').hasMatch(value);
  }

  //// ************ Circle Indicator ***********\\\\\
  Future<void> showProgress() async {
    Get.dialog(
        barrierColor: _colors.whiteColour.withOpacity(0.8),
        barrierDismissible: false,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(_images.loader, height: 150, width: 150),
            UIHelper.verticalSpaceSmall,
            UIHelper.titleTxtStyle("Loading...", fntWeight: FontWeight.bold, fntsize: 15, fntcolor: _colors.bluecolor)
          ],
        ));
  }

//// ************ Hide Indicator ***********\\\\\
  Future<void> hideProgress(BuildContext context) async {
     context.pop();
  }

  //// ************ Show Toast ***********\\\\\
  void showToast(String title, String message, {Color bgclr = Colors.red}) {
    Get.snackbar(title, message,
        animationDuration: const Duration(milliseconds: 800),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: bgclr,
        colorText: _colors.whiteColour,
        margin: const EdgeInsets.fromLTRB(30, 0, 30, 30));
  }

  //// ************ Popup Alert ***********\\\\\
  Future<void> showAlert(String contentType, String message, {final onComplete, final onBackPress, final subTitle}) async {
    await Get.dialog<void>(
      barrierDismissible: false,
      CustomAlert(title: contentType, message: message, onBackPress: onBackPress ?? () {}, onClickOK: onComplete ?? () {}, subTitle: subTitle ?? ""),
    );
  }

getWidgetHeight(context){
  return MediaQuery.of(context).size.height;
}

getWidgetWidth(context){
  return MediaQuery.of(context).size.width;
}

}
