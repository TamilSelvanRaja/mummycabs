import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
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
  String fromDate = "", toDate = "";
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();

  String cusId = "";
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
    await AppController().getcarList("customer_list");
    await AppController().getcarList("duty_details_get");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      body: SingleChildScrollView(
        child: Column(
          children: [
            customAppBar(),
            menuitemCards1(),
            menuItemCards(),
            UIHelper.verticalSpaceSmall,
            GestureDetector(
              onTap: () {
                fromDate = "";
                toDate = "";
                cusId = "";
                fgbottomsheet(1);
                //
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                width: Get.width,
                margin: const EdgeInsets.symmetric(horizontal: 26),
                decoration: UIHelper.roundedBorderWithColor(30, 3, 3, 30, _colors.bgClr, isShadow: true, shadowColor: _colors.greenColour),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(_images.destination, height: 50, width: 50),
                    UIHelper.horizontalSpaceSmall,
                    UIHelper.titleTxtStyle("Company Trips", fntsize: 16, fntcolor: _colors.primarycolour, txtAlign: TextAlign.center, fntWeight: FontWeight.bold),
                  ],
                ),
              ),
            ),
            UIHelper.verticalSpaceSmall,
          ],
        ),
      ),
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(2, (index) {
            return GestureDetector(
              onTap: () async {
                if (index == 0) {
                  await Get.toNamed(Routes.companyaddEditTrip, arguments: {"isedit": false});
                } else {
                  await Get.toNamed(Routes.starttrip, arguments: {"isedit": false});
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      padding: const EdgeInsets.all(8),
                      decoration: UIHelper.circleWithColorWithShadow(1, _colors.primarycolour, _colors.primarycolour),
                      child: Icon(index == 0 ? Icons.add_business_outlined : Icons.directions_car_outlined, size: 40, color: _colors.bgClr)),
                  UIHelper.titleTxtStyle(index == 0 ? "Company Trip" : "Drivers Trip", fntsize: 12, fntcolor: _colors.primarycolour, txtAlign: TextAlign.center, fntWeight: FontWeight.bold),
                ],
              ),
            );
          })),
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

  Widget menuitemCards1() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(menuTitleList.length, (index) {
          dynamic currentdata = menuTitleList[index];
          return GestureDetector(
            onTap: () async {
              if (index == 0) {
                Get.toNamed(Routes.cardetails);
              } else if (index == 1) {
                Get.toNamed(Routes.driverlist);
              } else {
                await Get.toNamed(Routes.customerList);
                setState(() {});
              }
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: UIHelper.circleWithColorWithShadow(1, _colors.whiteColour, _colors.greycolor1, borderColor: _colors.greycolor1),
                  child: Image.asset(currentdata['image'], height: Get.width / 5, width: Get.width / 5),
                ),
                UIHelper.verticalSpaceTiny,
                UIHelper.titleTxtStyle(currentdata['title'], fntsize: 12, fntcolor: _colors.primarycolour, txtAlign: TextAlign.center, fntWeight: FontWeight.bold),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget menuItemCards() {
    return Wrap(
        children: List.generate(
      menuTitleList1.length,
      (index) {
        dynamic currentdata = menuTitleList1[index];

        return GestureDetector(
          onTap: () async {
            if (index == 0) {
              Get.toNamed(Routes.triplist);
            } else {
              await Get.toNamed(Routes.pendingtriplist);
              setState(() {});
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            width: Get.width / 2.5,
            margin: const EdgeInsets.all(10),
            decoration: UIHelper.gradientContainer1(25, 0, 0, 25, index == 0 ? _colors.gradient1 : _colors.gradient2, isShadow: true, shadowColor: _colors.greycolor),
            //     decoration: UIHelper.roundedBorderWithColor(25, 0, 0, 25, _colors.bgClr, isShadow: true, shadowColor: _colors.greycolor),
            child: Column(
              children: [
                Image.asset(currentdata['image'], height: 80, width: 80),
                UIHelper.verticalSpaceSmall,
                UIHelper.titleTxtStyle(currentdata['title'], fntsize: 18, fntcolor: _colors.blackColour, txtAlign: TextAlign.center, fntWeight: FontWeight.bold),
              ],
            ),
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
          fromDate = "";
          toDate = "";
          cusId = "";
          fgbottomsheet(i);
        } else if (i == 2) {
          dutydetailsEditDialog();
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
          child: itemWidget("Trips Reports", 0, Icons.receipt_long_sharp),
        ),
        PopupMenuItem<String>(
          child: itemWidget("Settings", 2, Icons.settings),
        ),
        PopupMenuItem<String>(
          child: itemWidget("Logout", 3, Icons.logout_rounded),
        ),
      ],
      elevation: 8.0,
    );
  }

  Future fgbottomsheet(int index) {
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
                        UIHelper.titleTxtStyle(index == 0 ? "Trips Report" : "Company Trips", fntcolor: _colors.primarycolour, fntsize: 20, fntWeight: FontWeight.bold, txtAlign: TextAlign.center),
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
                if (index == 1) ...[
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: Get.width,
                      child: CustomDropDown(
                          initList: pref.customersList,
                          initValue: cusId,
                          hintText: "Customer Name",
                          fieldname: "customer_id",
                          onSelected: (val) {
                            cusId = val;
                            setState(() {});
                          })),
                  UIHelper.verticalSpaceSmall,
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                          child: CustomDatePicker(
                              hintText: "Start Date",
                              fieldname: "pi_time",
                              onSelected: (val) {
                                fromDate = val.toString();
                                setState(() {});
                              })),
                      UIHelper.horizontalSpaceSmall,
                      Expanded(
                          child: CustomDatePicker(
                              hintText: "End Date",
                              fieldname: "pickup_time",
                              onSelected: (val) {
                                toDate = val.toString();
                                setState(() {});
                              })),
                    ],
                  ),
                ),
                UIHelper.verticalSpaceMedium,
                Center(
                  child: InkWell(
                    onTap: () async {
                      if (fromDate.isNotEmpty && toDate.isNotEmpty) {
                        if (index == 0) {
                          Get.back();
                          await AppController().generateMonthlyReport(fromDate, toDate);
                        } else {
                          if (cusId.isNotEmpty) {
                            Get.back();
                            Get.toNamed(Routes.companyTripList, arguments: {"cusId": cusId, "from": fromDate, "to": toDate});
                          }
                        }
                      }
                    },
                    child: Container(
                      decoration: UIHelper.roundedBorderWithColor(10, 10, 10, 10, _colors.primarycolour),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                      child: UIHelper.titleTxtStyle(index == 0 ? "Generate Email" : "Next", fntsize: 16, fntcolor: _colors.bgClr, fntWeight: FontWeight.bold),
                    ),
                  ),
                ),
                UIHelper.verticalSpaceMedium,
              ],
            );
          }),
        ]);
      },
    );
  }

  Future dutydetailsEditDialog() async {
    await Get.dialog<void>(barrierDismissible: false, StatefulBuilder(builder: (context, setState) {
      return MediaQuery.removeViewInsets(
          removeBottom: true,
          context: context,
          child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              backgroundColor: _colors.bgClr,
              insetPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                        height: 50,
                        decoration: UIHelper.roundedBorderWithColor(16, 16, 0, 0, _colors.primarycolour),
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Expanded(child: UIHelper.titleTxtStyle("Duty Fess", fntcolor: _colors.bgClr, fntsize: 18)),
                            InkWell(
                              onTap: (() {
                                Get.back();
                              }),
                              child: Icon(Icons.close_rounded, size: 30, color: _colors.bgClr),
                            ),
                          ],
                        )),
                    UIHelper.verticalSpaceMedium,
                    FormBuilder(
                      key: _formkey,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(children: [
                            CustomInput(hintText: "One Hour Amount", initValue: pref.dutyDetails['hr_amount'], fieldname: "hr_amount", fieldType: "number"),
                            UIHelper.verticalSpaceSmall,
                            CustomInput(hintText: "Extra Amount per KM", initValue: pref.dutyDetails['ex_km_amount'], fieldname: "ex_km_amount", fieldType: "number"),
                            UIHelper.verticalSpaceMedium,
                            CustomInput(hintText: "Maximum KM per hour", initValue: pref.dutyDetails['per_hr_km'], fieldname: "per_hr_km", fieldType: "number"),
                            UIHelper.verticalSpaceMedium,
                            UIHelper().actionButton("Submit", 16, Get.width / 3, onPressed: () {
                              if (_formkey.currentState!.saveAndValidate()) {
                                Map<String, dynamic> postParams = Map.from(_formkey.currentState!.value);
                                postParams['uid'] = pref.dutyDetails["_id"];
                                postParams['service_id'] = "duty_details_edit";
                                AppController().dutyDetailsUpdate(postParams);
                              }
                            }),
                          ])),
                    ),
                    UIHelper.verticalSpaceMedium,
                  ],
                ),
              )));
    }));
  }
}
