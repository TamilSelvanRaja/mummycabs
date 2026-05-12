import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/static_datas.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/go_router_services.dart';
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

  String fromDate = "", toDate = "";
  String cusId = "";
  List tempCusList = [];
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();

  List<String> contentMenu = ["Driver Trip", "Company Trip", "Trips Report", "Settings", "Logout"];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future initialize() async {
    tempCusList = await PreferenceService().getArrayData("customersList");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: Utils().getWidgetWidth(context) / 1.5,
            child: Column(
              children: [
                UIHelper.verticalSpaceMedium2,
                menuitemCards1(),
                UIHelper.verticalSpaceMedium2,
                menuItemCards(),
                UIHelper.verticalSpaceMedium2,
                GestureDetector(
                  onTap: () {
                    reportmailDialog(1);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: Utils().getWidgetWidth(context),
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
                context.push(Routes.cardetails);
              } else if (index == 1) {
                context.push(Routes.driverlist);
              } else {
                context.push(Routes.customerList);
              }
            },
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: Utils().getWidgetWidth(context) / 4,
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
                context.push(Routes.triplist);
              } else {
                context.push(Routes.pendingtriplist);
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
                    width: Utils().getWidgetWidth(context) / 6,
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

  Future reportmailDialog(int selectIndex) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
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
                            Expanded(child: UIHelper.titleTxtStyle(selectIndex == 0 ? "Trips Report" : "Company Trips List", fntcolor: _colors.bgClr, fntsize: 18)),
                            InkWell(
                              onTap: (() {
                                context.pop();
                              }),
                              child: Icon(Icons.close_rounded, size: 30, color: _colors.bgClr),
                            ),
                          ],
                        )),
                    UIHelper.verticalSpaceMedium,
                    if (selectIndex == 1) ...[
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CustomDropDown(
                              initList: tempCusList,
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
                          UIHelper().actionButton(selectIndex == 0 ? "Generate Email" : "Continue", 16, Utils().getWidgetWidth(context) / 3, onPressed: () async {
                            if (fromDate.isNotEmpty && toDate.isNotEmpty) {
                              if (selectIndex == 0) {
                                context.pop();
                                await AppController().generateMonthlyReport(context, fromDate, toDate);
                              } else {
                                if (cusId.isNotEmpty) {
                                  context.pop();
                                  context.push(Routes.companyTripList, extra: {"cusId": cusId, "from": fromDate, "to": toDate});
                                }
                              }
                            }
                          }),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpaceMedium,
                  ],
                ),
              ));
        });
  }

  Future dutydetailsEditDialog() async {
    dynamic dutyDetails = await PreferenceService().getjsonData("dutyDetails");

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
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
                                context.pop();
                                ;
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
                            CustomInput(hintText: "One Hour Amount", initValue: dutyDetails['hr_amount'], fieldname: "hr_amount", fieldType: "number"),
                            UIHelper.verticalSpaceSmall,
                            CustomInput(hintText: "Extra Amount per KM", initValue: dutyDetails['ex_km_amount'], fieldname: "ex_km_amount", fieldType: "number"),
                            UIHelper.verticalSpaceMedium,
                            CustomInput(hintText: "Maximum KM per hour", initValue: dutyDetails['per_hr_km'], fieldname: "per_hr_km", fieldType: "number"),
                            UIHelper.verticalSpaceMedium,
                            UIHelper().actionButton("Submit", 16, Utils().getWidgetWidth(context) / 3, onPressed: () {
                              if (_formkey.currentState!.saveAndValidate()) {
                                Map<String, dynamic> postParams = Map.from(_formkey.currentState!.value);
                                postParams['uid'] = dutyDetails["_id"];
                                postParams['service_id'] = "duty_details_edit";
                                AppController().dutyDetailsUpdate(context, postParams);
                              }
                            }),
                          ])),
                    ),
                    UIHelper.verticalSpaceMedium,
                  ],
                ),
              ));
        });
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      toolbarHeight: 90,
      elevation: 0,
      automaticallyImplyLeading: false,
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
              context.push(Routes.starttrip, extra: {"isedit": false});
            } else if (index == 1) {
              context.push(Routes.companyaddEditTrip, extra: {"isedit": false});
            } else if (index == 2) {
              fromDate = "";
              toDate = "";

              reportmailDialog(0);
            } else if (index == 3) {
              dutydetailsEditDialog();
            } else {
              Utils().showAlert(context, "O", "Do you want to logout?", subTitle: "Logout", onComplete: () {
                context.go(Routes.login);

                PreferenceService().cleanAllPreferences();
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
