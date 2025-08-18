import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/static_datas.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();
  final PreferenceService pref = Get.find<PreferenceService>();
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      initialize();
    });
  }

  Future initialize() async {
    await AppController().getcarList("car_list");
    await AppController().getcarList("drivers_list");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.whiteColour,
      body: Column(
        children: [
          customAppBar(),
          detailsCard(),
          UIHelper.verticalSpaceMedium,
          // Expanded(
          //   child: Stack(
          //     children: [
          //       Positioned(
          //           top: 0,
          //           child: Container(
          //             width: Get.width,
          //             alignment: Alignment.center,
          //             child: Container(
          //               height: 40,
          //               width: Get.width / 1.5,
          //               decoration: UIHelper.roundedBorderWithColor(30, 30, 30, 30, _colors.bgClr, borderColor: _colors.primarycolour, isShadow: true, shadowColor: _colors.primarycolour),
          //               alignment: Alignment.center,
          //               child: UIHelper.titleTxtStyle("Make a receipt", fntWeight: FontWeight.bold, fntsize: 16),
          //             ),
          //           ))
          //     ],
          //   ),
          // )
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Get.toNamed(Routes.starttrip);
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          width: Get.width / 2,
          decoration: UIHelper.roundedBorderWithColor(30, 30, 30, 30, _colors.bluecolor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UIHelper.titleTxtStyle("Start Trip", fntcolor: _colors.bgClr, fntsize: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget customAppBar() {
    return Container(
        width: Get.width,
        padding: const EdgeInsets.fromLTRB(16, 35, 16, 10),
        color: _colors.primarycolour,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            pref.userdata['imgurl'] != null
                ? CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage("${ApiServices().apiurl}/${pref.userdata['imgurl']}"),
                  )
                : Image.asset(_images.profile, height: 50, width: 50),
            UIHelper.titleTxtStyle("${pref.userdata['name']}", fntcolor: _colors.bgClr, fntsize: 20, fntWeight: FontWeight.bold, txtAlign: TextAlign.center),
            InkWell(
                onTap: () {
                  Utils().showAlert("O", "Do you want to logout?", subTitle: "Logout", onComplete: () {
                    pref.cleanAllPreferences();
                    Get.offNamedUntil(Routes.initial, (p) => false);
                  });
                },
                child: Icon(Icons.logout, size: 26, color: _colors.bgClr)),
          ],
        ));
  }

  Widget detailsCard() {
    return Stack(
      children: [
        Container(height: 40, color: _colors.primarycolour),
        Row(
            children: List.generate(adminTitleList.length, (index) {
          dynamic currentdata = adminTitleList[index];
          return Expanded(
            child: InkWell(
              onTap: () {
                if (index == 0) {
                  Get.toNamed(Routes.cardetails);
                } else {
                  Get.toNamed(Routes.driverdetails);
                }
              },
              child: Container(
                height: 60,
                margin: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                padding: const EdgeInsets.all(8),
                decoration: UIHelper.roundedBorderWithColor(15, 15, 15, 15, _colors.whiteColour, isShadow: true, shadowColor: _colors.greycolor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Image.asset(currentdata['image']), UIHelper.horizontalSpaceSmall, UIHelper.titleTxtStyle(currentdata['title'], fntWeight: FontWeight.bold)],
                ),
              ),
            ),
          );
        })),
      ],
    );
  }
}
