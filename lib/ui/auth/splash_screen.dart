import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppImages _images = AppImages();
  final AppColors _colors = AppColors();
  bool isShowjeep = true;
  final PreferenceService pref = Get.find<PreferenceService>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      isShowjeep = false;
      setState(() {});
    });

    Future.delayed(const Duration(seconds: 2), () {
      initializate();
    });
  }

  initializate() async {
    if (await pref.getString("mobile") != "" && await pref.getString("password") != "") {
      dynamic postParams = {"service_id": "login", "mobile": await pref.getString("mobile"), "password": await pref.getString("password")};
      AppController().loginFunction(postParams);
    } else {
      Get.offNamedUntil(Routes.login, (p) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      body: SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UIHelper.titleTxtStyle("Mummy Cab's", fntcolor: _colors.primarycolour, fntsize: 70, fntWeight: FontWeight.bold, txtAlign: TextAlign.center),
            UIHelper.verticalSpaceSmall,
            Image.asset(_images.loader, height: 200, width: 200),
          ],
        ),
      ),
    );
  }
}
