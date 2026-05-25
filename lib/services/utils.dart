import 'package:flutter/material.dart';

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
  Future<void> showProgress(BuildContext context) async {
    showDialog(
        barrierColor: _colors.greycolor.withOpacity(0.5),
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
                width: 200,
                height: 300,
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(_images.loader, height: 150, width: 150),
                    UIHelper.verticalSpaceSmall,
                    UIHelper.titleTxtStyle("Loading...", fntWeight: FontWeight.bold, fntsize: 15, fntcolor: _colors.bluecolor)
                  ],
                )),
          );
        });
  }

//// ************ Hide Indicator ***********\\\\\
  Future<void> hideProgress(BuildContext context) async {
    context.pop();
  }

  //// ************ Show Toast ***********\\\\\
  void showToast(BuildContext context, String title, String message, {Color bgclr = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 30, color: _colors.whiteColour),
            ),
            Text(
              message,
              style: TextStyle(fontSize: 20, color: _colors.whiteColour),
            ),
          ],
        ),
        backgroundColor: bgclr,
        margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 800),
      ),
    );
    // Get.snackbar(title, message,
    //     animationDuration: const Duration(milliseconds: 800),
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: bgclr,
    //     colorText: _colors.whiteColour,
    //     margin: const EdgeInsets.fromLTRB(30, 0, 30, 30));
  }

  //// ************ Popup Alert ***********\\\\\
  Future<void> showAlert(BuildContext context, String contentType, String message, {final onComplete, final onBackPress, final subTitle}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return CustomAlert(title: contentType, message: message, onBackPress: onBackPress ?? () {}, onClickOK: onComplete ?? () {}, subTitle: subTitle ?? "");
        });
  }

  getWidgetHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  getWidgetWidth(context) {
    return MediaQuery.of(context).size.width;
  }
}
