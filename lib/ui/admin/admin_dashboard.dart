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
import 'package:intl/intl.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();
  final PreferenceService pref = Get.find<PreferenceService>();
  List selectedIndex = [];
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
          Expanded(
              child: ListView.builder(
                  itemCount: pref.starttripList.length,
                  itemBuilder: (context, index) {
                    dynamic currentData = pref.starttripList[index];
                    return cardData(index, currentData);
                  }))
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          await Get.toNamed(Routes.starttrip);
          setState(() {});
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

  Widget rowdata(String t1, String t2, String t3, bool isheading, String prefixTxt) {
    return Row(
      children: [
        Expanded(flex: 2, child: UIHelper.titleTxtStyle(t1, fntsize: 14, fntWeight: isheading ? FontWeight.bold : FontWeight.normal)),
        Expanded(flex: 2, child: UIHelper.titleTxtStyle("$prefixTxt $t2", fntsize: 14, fntWeight: isheading ? FontWeight.bold : FontWeight.normal)),
        Expanded(flex: 2, child: UIHelper.titleTxtStyle("$prefixTxt $t3", fntsize: 14, fntWeight: isheading ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget rowdata1(String t1, String t2, String prefixTxt) {
    return Row(
      children: [
        Expanded(flex: 3, child: UIHelper.titleTxtStyle(t1, fntsize: 14, fntWeight: FontWeight.normal)),
        Expanded(flex: 1, child: UIHelper.titleTxtStyle(":", fntsize: 14, fntWeight: FontWeight.normal)),
        Expanded(flex: 2, child: UIHelper.titleTxtStyle("$prefixTxt $t2", fntsize: 14, fntWeight: FontWeight.bold)),
      ],
    );
  }

  Widget cardData(int index, dynamic currentData) {
    List amountList = currentData['amount_details'];
    log("$currentData");
    dynamic user = Utils().getDriverdetails("${currentData['driver_id']}");

    DateTime inputDate = DateTime.parse(currentData['trip_date'].toString());
    DateFormat format = DateFormat('dd-MM-yyyy');
    String formattedDate = format.format(inputDate);

    return GestureDetector(
      onTap: () {
        if (selectedIndex.contains(index)) {
          selectedIndex.remove(index);
        } else {
          selectedIndex.add(index);
        }
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, _colors.whiteColour, isShadow: true, shadowColor: _colors.primarycolour),
        child: Column(
          children: [
            Row(
              children: [
                user['imgurl'] != null
                    ? CircleAvatar(
                        radius: 25,
                        backgroundColor: _colors.primarycolour,
                        backgroundImage: NetworkImage("${ApiServices().apiurl}/${user['imgurl']}"),
                      )
                    : Image.asset(_images.profile, height: 50, width: 50),
                UIHelper.horizontalSpaceSmall,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIHelper.titleTxtStyle(user['name'], fntcolor: _colors.primarycolour, fntsize: 14, fntWeight: FontWeight.bold),
                    UIHelper.titleTxtStyle(currentData['vehicle_no'], fntcolor: _colors.textColour, fntsize: 12, fntWeight: FontWeight.bold),
                    UIHelper.titleTxtStyle("Date : $formattedDate", fntcolor: _colors.textColour, fntsize: 12, fntWeight: FontWeight.bold),
                  ],
                )
              ],
            ),
            if (selectedIndex.contains(index)) ...[
              Divider(color: _colors.primarycolour),
              rowdata("Company", "Cash", "Operatot", true, ""),
              UIHelper.verticalSpaceSmall,
              Column(
                children: List.generate(amountList.length, (i) {
                  Map<String, dynamic> data = amountList[i];
                  return rowdata("${data['type']}", "${data['cash']}", "${data['operator']}", false, "₹");
                }),
              ),
              const Divider(),
              rowdata("Total", "${currentData['over_all_cash']}", "${currentData['over_all_operator']}", true, "₹"),
              const Divider(),
              UIHelper.verticalSpaceSmall,
              rowdata1("Driver Salary", "${currentData['driversalary']}", "₹"),
              UIHelper.verticalSpaceSmall,
              rowdata1("Fuel Amount", "${currentData['fuel_amt']}", "₹"),
              UIHelper.verticalSpaceSmall,
              rowdata1("Balance Amount", "${currentData['needtopay']}", "₹"),
              UIHelper.verticalSpaceSmall,
              UIHelper.titleTxtStyle("*****************", fntcolor: _colors.bluecolor, fntsize: 16),
              UIHelper.verticalSpaceSmall,
              UIHelper().actionButton("Amount Received", 8, Get.width / 2, bgcolour: _colors.primarycolour, onPressed: () {})
            ]
          ],
        ),
      ),
    );
  }
}
