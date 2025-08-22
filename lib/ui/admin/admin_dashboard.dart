import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
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
      backgroundColor: _colors.bgClr,
      body: Column(
        children: [
          customAppBar(),
          UIHelper.verticalSpaceMedium,
          menuItemCards(),
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          await Get.toNamed(Routes.starttrip, arguments: {"isedit": false});
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          width: Get.width / 2,
          decoration: UIHelper.roundedBorderWithColor(30, 30, 30, 30, _colors.primarycolour),
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
                    radius: 25,
                    backgroundImage: NetworkImage("${ApiServices().apiurl}/${pref.userdata['imgurl']}"),
                  )
                : Image.asset(_images.adminprofile, height: 50, width: 50),
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

  Widget menuItemCards() {
    return Column(
        children: List.generate(
      menuTitleList.length,
      (index) {
        dynamic currentdata = menuTitleList[index];
        return GestureDetector(
          onTap: () {
            if (index == 0) {
              Get.toNamed(Routes.triplist);
            } else if (index == 1) {
              Get.toNamed(Routes.driverdetails);
            } else {
              Get.toNamed(Routes.cardetails);
            }
          },
          child: Container(
            height: 100,
            margin: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            padding: const EdgeInsets.all(16),
            decoration: UIHelper.roundedBorderWithColor(15, 15, 15, 15, _colors.whiteColour, isShadow: true, shadowColor: _colors.primarycolour),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(currentdata['image']),
                UIHelper.titleTxtStyle(currentdata['title'], fntsize: 25, fntcolor: _colors.primarycolour, fntWeight: FontWeight.bold),
                Icon(Icons.forward, color: _colors.primarycolour)
              ],
            ),
          ),
        );
      },
    ));
  }
}
