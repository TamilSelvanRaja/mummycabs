import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/go_router_services.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AppImages _images = AppImages();
  final AppColors _colors = AppColors();
 
  @override
  void initState() {
    super.initState();
   ;

    Future.delayed(const Duration(seconds: 2), () {
      initializate();
    });
  }

  initializate() async {   
     if (await PreferenceService().getString("mobile") != "" && await PreferenceService().getString("password") != "") {
       dynamic postParams = {"service_id": "login", "mobile": await PreferenceService().getString("mobile"), "password": await PreferenceService().getString("password")};
      AppController().loginFunction(context,postParams);
     } else {
     context.go(Routes.login);
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      body: SizedBox(
        width:  Utils().getWidgetWidth(context),
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
