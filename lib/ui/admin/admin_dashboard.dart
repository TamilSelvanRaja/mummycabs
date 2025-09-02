import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
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
  String inputDate = "";
  String downloadFilepath = "";
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
            decoration: UIHelper.circleWithColorWithShadow(1, _colors.primarycolour, _colors.primarycolour),
            child: Icon(Icons.directions_car_outlined, size: 40, color: _colors.bgClr)
            // UIHelper.titleTxtStyle("Start Trip", fntcolor: _colors.bgClr, fntsize: 16),
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
            InkWell(onTap: () => _showPopupMenu(), child: Icon(Icons.menu_rounded, size: 30, color: _colors.whiteColour)),
          ],
        ));
  }

  Widget menuItemCards() {
    return Wrap(
        children: List.generate(
      menuTitleList.length,
      (index) {
        dynamic currentdata = menuTitleList[index];
        return GestureDetector(
          onTap: () async {
            if (index == 0) {
              Get.toNamed(Routes.driverlist);
            } else if (index == 1) {
              Get.toNamed(Routes.cardetails);
            } else if (index == 2) {
              Get.toNamed(Routes.triplist);
            } else {
              await Get.toNamed(Routes.pendingtriplist);
              setState(() {});
            }
          },
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                width: Get.width / 2.5,
                margin: const EdgeInsets.all(10),
                decoration: UIHelper.roundedBorderWithColor(15, 15, 15, 15, _colors.bgClr, isShadow: true, shadowColor: _colors.greycolor),
                child: Column(
                  children: [
                    Image.asset(currentdata['image'], height: 80, width: 80),
                    UIHelper.verticalSpaceSmall,
                    UIHelper.titleTxtStyle(currentdata['title'], fntsize: 18, fntcolor: _colors.primarycolour, txtAlign: TextAlign.center, fntWeight: FontWeight.bold),
                  ],
                ),
              ),
              if (index == 3 && pref.pendingTripList.isNotEmpty)
                Positioned(
                  right: 0,
                  child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: UIHelper.circleWithColorWithShadow(1, _colors.bluecolor, _colors.bluecolor),
                    child: UIHelper.titleTxtStyle("${pref.pendingTripList.length}", fntcolor: _colors.bgClr, fntWeight: FontWeight.bold),
                  ),
                )
            ],
          ),
        );
      },
    ));
  }

  itemWidget(title, int i, IconData icon) {
    return InkWell(
      onTap: () {
        Get.back();
        if (i == 0) {
          inputDate = "";
          downloadFilepath = "";
          fgbottomsheet();
        } else {
          Utils().showAlert("O", "Do you want to logout?", subTitle: "Logout", onComplete: () {
            pref.cleanAllPreferences();
            Get.offNamedUntil(Routes.initial, (p) => false);
          });
        }
      },
      child: Row(
        children: [
          Icon(
            icon,
            color: _colors.primarycolour,
          ),
          UIHelper.horizontalSpaceTiny,
          UIHelper.titleTxtStyle(title)
        ],
      ),
    );
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width - 40, kToolbarHeight, 10, 0),
      items: [
        PopupMenuItem<String>(
          child: itemWidget("Generate Reports", 0, Icons.receipt_long_sharp),
        ),
        PopupMenuItem<String>(
          child: itemWidget("Logout", 1, Icons.logout_rounded),
        ),
      ],
      elevation: 8.0,
    );
  }

  Future fgbottomsheet() {
    return showModalBottomSheet(
      backgroundColor: _colors.whiteColour,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return Wrap(children: [
          StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.verticalSpaceSmall,
                Center(
                  child: Container(
                    height: Get.height / 80,
                    width: Get.width / 5,
                    decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, _colors.greycolor),
                  ),
                ),
                UIHelper.verticalSpaceMedium,
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UIHelper.titleTxtStyle("Generate Files", fntcolor: _colors.primarycolour, fntsize: 20, fntWeight: FontWeight.bold, txtAlign: TextAlign.center),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.cancel_outlined,
                            color: _colors.redColour,
                            size: 30,
                          ),
                        ),
                      ],
                    )),
                UIHelper.verticalSpaceMedium,
                Center(
                  child: GestureDetector(
                      onTap: () async {
                        showMonthPicker(context, onSelected: (month, year) async {
                          String mm = month.toString();
                          if (mm.length == 1) {
                            mm = "0$mm";
                          }
                          inputDate = '$mm-$year';
                          downloadFilepath = await AppController().generateMonthlyReport(inputDate);
                          setState(() {});
                        },
                            initialSelectedMonth: DateTime.now().month,
                            initialSelectedYear: DateTime.now().year,
                            firstYear: 2023,
                            lastYear: DateTime.now().year,
                            selectButtonText: 'OK',
                            cancelButtonText: 'Cancel',
                            highlightColor: _colors.primarycolour,
                            textColor: Colors.black,
                            contentBackgroundColor: Colors.white,
                            dialogBackgroundColor: Colors.grey[200]);
                      },
                      child: Container(
                        width: Get.width / 2,
                        decoration: UIHelper.roundedBorderWithColor(10, 10, 10, 10, _colors.whiteColour, borderWidth: 1, borderColor: _colors.greycolor),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_month, size: 20, color: _colors.greycolor),
                            UIHelper.horizontalSpaceSmall,
                            UIHelper.titleTxtStyle(inputDate.isNotEmpty ? inputDate : "Select Month"),
                          ],
                        ),
                      )),
                ),
                UIHelper.verticalSpaceMedium,
                if (downloadFilepath.isNotEmpty) ...[
                  InkWell(
                    onTap: () {
                      AppController().downloadImage(inputDate, downloadFilepath);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(_images.excel, height: 80, width: 80),
                        UIHelper.horizontalSpaceSmall,
                        UIHelper.titleTxtStyle("Download", fntsize: 16, fntcolor: _colors.bluecolor, fntWeight: FontWeight.bold),
                      ],
                    ),
                  ),
                ],
                UIHelper.verticalSpaceVeryLarge,
              ],
            );
          }),
        ]);
      },
    );
  }
}
