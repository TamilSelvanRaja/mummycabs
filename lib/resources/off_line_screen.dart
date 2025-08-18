import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';

class NoInternet extends StatelessWidget {
  NoInternet({super.key});
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      body: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(_images.loader, height: 100, width: 100),
            UIHelper.verticalSpaceSmall,
            UIHelper.titleTxtStyle("No Internet", fntcolor: Colors.red, fntsize: 16, fntWeight: FontWeight.bold),
            UIHelper.verticalSpaceTiny,
            UIHelper.titleTxtStyle("Please check your network connection", fntcolor: Colors.black54, fntsize: 14),
          ],
        ),
      ),
    );
  }
}
