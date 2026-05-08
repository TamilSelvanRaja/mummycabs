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
  String fromDate = "", toDate = "";
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();

  List<String> contentMenu = ["Driver Trip", "Company Trip", "Trips Report", "Settings", "Logout"];

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
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: Get.width / 1.5,
            child: Column(
              children: [
                UIHelper.verticalSpaceMedium2,
                menuitemCards1(),
                UIHelper.verticalSpaceMedium2,
                menuItemCards(),
                UIHelper.verticalSpaceMedium2,
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.companyTripList);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: Get.width,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: UIHelper.roundedBorderWithColor(15, 15, 15, 15, _colors.lightgreen, isShadow: true, shadowColor: Colors.black12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(_images.destination, height: 50, width: 50),
                        UIHelper.horizontalSpaceSmall,
                        UIHelper.titleTxtStyle("Company Trip List", fntsize: 16, fntcolor: _colors.primarycolour, txtAlign: TextAlign.center, fntWeight: FontWeight.bold),
                        const Spacer(),
                        Container(
                          width: 250,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: UIHelper.roundedBorderWithColor(10, 10, 10, 10, _colors.greenColour),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              UIHelper.titleTxtStyle("View Company Trips", fntsize: 13, fntWeight: FontWeight.bold, fntcolor: Colors.white),
                              Icon(Icons.arrow_forward_outlined, color: _colors.whiteColour)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                UIHelper.verticalSpaceSmall,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget menuitemCards1() {
    return Row(
      children: List.generate(menuTitleList.length, (index) {
        dynamic currentdata = menuTitleList[index];
        return Expanded(
          child: GestureDetector(
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
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: Get.width / 4,
                    decoration: UIHelper.roundedBorderWithColor(10, 10, 10, 10, _colors.whiteColour, isShadow: true, shadowColor: Colors.black12),
                    child: Column(
                      children: [
                        Image.asset(currentdata['image'], height: 150, width: 150),
                        UIHelper.verticalSpaceSmall,
                        UIHelper.titleTxtStyle(currentdata['title'], fntsize: 20, txtAlign: TextAlign.center, fntWeight: FontWeight.bold),
                        UIHelper.verticalSpaceTiny,
                        UIHelper.titleTxtStyle(currentdata['desc'], fntsize: 15, fntcolor: Colors.black45, txtAlign: TextAlign.center, fntWeight: FontWeight.bold),
                        //Icon(Icons.arrow_circle_right_outlined, color: _colors.primarycolour, size: 40),
                      ],
                    )),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget menuItemCards() {
    return Row(
        children: List.generate(
      menuTitleList1.length,
      (index) {
        dynamic currentdata = menuTitleList1[index];

        return Expanded(
          child: GestureDetector(
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
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: UIHelper.gradientContainer1(20, 20, 20, 20, index == 0 ? _colors.gradient1 : _colors.gradient2, isShadow: true, shadowColor: Colors.black12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(currentdata['image'], height: 80, width: 80),
                      UIHelper.horizontalSpaceSmall,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          UIHelper.titleTxtStyle(currentdata['title'], fntsize: 18, fntcolor: _colors.blackColour, txtAlign: TextAlign.center, fntWeight: FontWeight.bold),
                          UIHelper.verticalSpaceTiny,
                          UIHelper.titleTxtStyle(currentdata['desc'], fntsize: 12, fntcolor: Colors.black54, txtAlign: TextAlign.center, fntWeight: FontWeight.bold),
                        ],
                      ),
                    ],
                  ),
                  UIHelper.verticalSpaceSmall,
                  Container(
                    width: 200,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: UIHelper.roundedBorderWithColor(10, 10, 10, 10, _colors.whiteColour),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        UIHelper.titleTxtStyle("View ${currentdata['title']}", fntsize: 13, fntWeight: FontWeight.bold, fntcolor: Colors.black87),
                        Icon(Icons.arrow_forward_outlined, color: _colors.redColour)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    ));
  }

  Future reportmailDialog() async {
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
                            Expanded(child: UIHelper.titleTxtStyle("Trips Report", fntcolor: _colors.bgClr, fntsize: 18)),
                            InkWell(
                              onTap: (() {
                                Get.back();
                              }),
                              child: Icon(Icons.close_rounded, size: 30, color: _colors.bgClr),
                            ),
                          ],
                        )),
                    UIHelper.verticalSpaceMedium,
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CustomDatePicker(
                              hintText: "Start Date",
                              fieldname: "pi_time",
                              onSelected: (val) {
                                fromDate = val.toString();
                                setState(() {});
                              }),
                          UIHelper.verticalSpaceSmall,
                          CustomDatePicker(
                              hintText: "End Date",
                              fieldname: "pickup_time",
                              onSelected: (val) {
                                toDate = val.toString();
                                setState(() {});
                              }),
                          UIHelper.verticalSpaceMedium,
                          UIHelper().actionButton("Generate Email", 16, Get.width / 3, onPressed: () async {
                            if (fromDate.isNotEmpty && toDate.isNotEmpty) {
                              Get.back();
                              await AppController().generateMonthlyReport(fromDate, toDate);
                            }
                          }),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpaceMedium,
                  ],
                ),
              )));
    }));
  }

  // Future fgbottomsheet() {
  //   return showModalBottomSheet(
  //     backgroundColor: _colors.whiteColour,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20),
  //         topRight: Radius.circular(20),
  //       ),
  //     ),
  //     context: context,
  //     builder: (context) {
  //       return Wrap(children: [
  //         StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
  //           return Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               UIHelper.verticalSpaceSmall,
  //               Center(
  //                 child: Container(
  //                   height: Get.height / 80,
  //                   width: Get.width / 5,
  //                   decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, _colors.greycolor),
  //                 ),
  //               ),
  //               UIHelper.verticalSpaceMedium,
  //               Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 16),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       UIHelper.titleTxtStyle("Trips Report" , fntcolor: _colors.primarycolour, fntsize: 20, fntWeight: FontWeight.bold, txtAlign: TextAlign.center),
  //                       InkWell(
  //                         onTap: () {
  //                           Get.back();
  //                         },
  //                         child: Icon(
  //                           Icons.cancel_outlined,
  //                           color: _colors.redColour,
  //                           size: 30,
  //                         ),
  //                       ),
  //                     ],
  //                   )),
  //               UIHelper.verticalSpaceMedium,
  //               if (index == 1) ...[
  //                 Container(
  //                     padding: const EdgeInsets.symmetric(horizontal: 16),
  //                     width: Get.width,
  //                     child: CustomDropDown(
  //                         initList: customersList,
  //                         initValue: cusId,
  //                         hintText: "Customer Name",
  //                         fieldname: "customer_id",
  //                         onSelected: (val) {
  //                           cusId = val;
  //                           setState(() {});
  //                         })),
  //                 UIHelper.verticalSpaceSmall,
  //               ],
  //               Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: 16),
  //                 child: Row(
  //                   children: [
  //                     Expanded(
  //                         child: CustomDatePicker(
  //                             hintText: "Start Date",
  //                             fieldname: "pi_time",
  //                             onSelected: (val) {
  //                               fromDate = val.toString();
  //                               setState(() {});
  //                             })),
  //                     UIHelper.horizontalSpaceSmall,
  //                     Expanded(
  //                         child: CustomDatePicker(
  //                             hintText: "End Date",
  //                             fieldname: "pickup_time",
  //                             onSelected: (val) {
  //                               toDate = val.toString();
  //                               setState(() {});
  //                             })),
  //                   ],
  //                 ),
  //               ),
  //               UIHelper.verticalSpaceMedium,
  //               Center(
  //                 child: InkWell(
  //                   onTap: () async {
  //                     if (fromDate.isNotEmpty && toDate.isNotEmpty) {
  //                       if (index == 0) {
  //                         Get.back();
  //                         await AppController().generateMonthlyReport(fromDate, toDate);
  //                       } else {
  //                         if (cusId.isNotEmpty) {
  //                           Get.back();
  //                           Get.toNamed(Routes.companyTripList, arguments: {"cusId": cusId, "from": fromDate, "to": toDate});
  //                         }
  //                       }
  //                     }
  //                   },
  //                   child: Container(
  //                     decoration: UIHelper.roundedBorderWithColor(10, 10, 10, 10, _colors.primarycolour),
  //                     padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
  //                     child: UIHelper.titleTxtStyle(index == 0 ? "Generate Email" : "Next", fntsize: 16, fntcolor: _colors.bgClr, fntWeight: FontWeight.bold),
  //                   ),
  //                 ),
  //               ),
  //               UIHelper.verticalSpaceMedium,
  //             ],
  //           );
  //         }),
  //       ]);
  //     },
  //   );
  // }

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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 90,
      elevation: 0,
      backgroundColor: _colors.primarycolour,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UIHelper.titleTxtStyle("Mummy Cabs", fntcolor: _colors.whiteColour, fntsize: 40, fntWeight: FontWeight.bold),
          UIHelper.titleTxtStyle("Manage Your profile and Trips", fntcolor: _colors.whiteColour, fntsize: 13, fntWeight: FontWeight.w400)
        ],
      ),
      actions: _buildDesktopMenu(),
    );
  }

  List<Widget> _buildDesktopMenu() {
    return List.generate(contentMenu.length, (index) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: () async {
            if (index == 0) {
              await Get.toNamed(Routes.starttrip, arguments: {"isedit": false});
            } else if (index == 1) {
              await Get.toNamed(Routes.companyaddEditTrip, arguments: {"isedit": false});
            } else if (index == 2) {
              fromDate = "";
              toDate = "";

              reportmailDialog();
            } else if (index == 3) {
              dutydetailsEditDialog();
            } else {
              Utils().showAlert("O", "Do you want to logout?", subTitle: "Logout", onComplete: () {
                pref.cleanAllPreferences();
                Get.offNamedUntil(Routes.initial, (p) => false);
              });
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: UIHelper.titleTxtStyle(contentMenu[index], fntsize: 18, fntWeight: FontWeight.bold, fntcolor: _colors.whiteColour),
            ),
          ),
        ),
      );
    });
  }
}
