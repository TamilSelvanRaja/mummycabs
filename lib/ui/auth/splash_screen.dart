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
      body: Column(
        children: [
          const Spacer(),
          UIHelper.titleTxtStyle("Mummy\nCab's", fntcolor: _colors.primarycolour, fntsize: 50, fntWeight: FontWeight.bold, txtAlign: TextAlign.center),
          const Spacer(),
          Center(child: AnimatedContainer(duration: const Duration(seconds: 1), height: isShowjeep ? 40 : Get.width, width: isShowjeep ? 40 : Get.width, child: Image.asset(_images.jeep))),
        ],
      ),
    );
  }
}
