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
          Expanded(
            child: Stack(
              children: [
                formWidget(),
                Positioned(
                    top: 0,
                    child: Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      child: Container(
                        height: 40,
                        width: Get.width / 1.5,
                        decoration: UIHelper.roundedBorderWithColor(30, 30, 30, 30, _colors.bgClr, borderColor: _colors.primarycolour, isShadow: true, shadowColor: _colors.primarycolour),
                        alignment: Alignment.center,
                        child: UIHelper.titleTxtStyle("Make a receipt", fntWeight: FontWeight.bold, fntsize: 16),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
      // floatingActionButton: InkWell(
      //   onTap: () {
      //     Get.toNamed(Routes.starttrip);
      //   },
      //   child: Container(
      //     padding: const EdgeInsets.all(8),
      //     width: Get.width / 2,
      //     decoration: UIHelper.roundedBorderWithColor(30, 30, 30, 30, _colors.bluecolor),
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         UIHelper.titleTxtStyle("Start Trip", fntcolor: _colors.bgClr, fntsize: 16),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Widget customAppBar() {
    return Container(
        width: Get.width,
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 10),
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

  Widget formWidget() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, _colors.bgClr, borderColor: _colors.primarycolour, isShadow: true, shadowColor: _colors.primarycolour),
      child: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              UIHelper.verticalSpaceMedium2,
              CustomDatePicker(hintText: "Trip Date", fieldname: "trip_date", onSelected: (val) {}),
              UIHelper.verticalSpaceSmall,
              CustomDropDown(initList: dummyCardetails, hintText: "Vehicle Number", fieldname: "vehicle_no", onSelected: (val) {}),
              UIHelper.verticalSpaceSmall,
              CustomDropDown(initList: dummydriverdetails, hintText: "Driver", fieldname: "driver_id", onSelected: (val) {}),
              UIHelper.verticalSpaceSmall,
              const CustomInput(hintText: "OLA Operatoe", fieldname: "ola_operator", fieldType: "novalidation"),
              UIHelper.verticalSpaceSmall,
              const CustomInput(hintText: "OLA Cash", fieldname: "ola_cash", fieldType: "novalidation"),
              UIHelper.verticalSpaceSmall,
              const CustomInput(hintText: "Uber Operator", fieldname: "uber_operator", fieldType: "novalidation"),
              UIHelper.verticalSpaceSmall,
              const CustomInput(hintText: "Uber Cash", fieldname: "uber_cash", fieldType: "novalidation"),
              UIHelper.verticalSpaceSmall,
              const CustomInput(hintText: "Rapido", fieldname: "rapido", fieldType: "novalidation"),
              UIHelper.verticalSpaceMedium,
              UIHelper().actionButton("Submit", 18, Get.width / 2, bgcolour: _colors.primarycolour, onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
                  postParams['service'] = "start_trip";
                  log("$postParams");
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
