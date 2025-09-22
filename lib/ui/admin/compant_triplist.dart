import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';
import 'package:provider/provider.dart';

class CompantTripList extends StatefulWidget {
  const CompantTripList({super.key});

  @override
  State<CompantTripList> createState() => _CompantTripListState();
}

class _CompantTripListState extends State<CompantTripList> {
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();
  final PreferenceService pref = Get.find<PreferenceService>();
  String selectedDate = "";
  String cusId = "";
  late AppController appController;

  @override
  void initState() {
    super.initState();
    DateTime inputDate = DateTime.now();
    DateFormat format = DateFormat('MM-yyyy');
    selectedDate = format.format(inputDate);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          final controller = AppController();

          return controller;
        })
      ],
      child: Consumer<AppController>(builder: (context, ref, child) {
        appController = ref;
        return Scaffold(
          backgroundColor: _colors.bgClr,
          appBar: AppBar(
            backgroundColor: _colors.primarycolour,
            centerTitle: true,
            iconTheme: IconThemeData(color: _colors.bgClr),
            title: UIHelper.titleTxtStyle("Company Trip List", fntcolor: _colors.bgClr, fntsize: 22),
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            height: Get.height,
            width: Get.width,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: CustomDropDown(
                            initList: pref.customersList,
                            initValue: cusId,
                            hintText: "Customer",
                            fieldname: "customer_id",
                            onSelected: (val) {
                              cusId = val;
                              setState(() {});
                            })),
                    UIHelper.horizontalSpaceSmall,
                    Expanded(
                        flex: 2,
                        child: GestureDetector(
                            onTap: () async {
                              showMonthPicker(context, onSelected: (month, year) async {
                                String mm = month.toString();
                                if (mm.length == 1) {
                                  mm = "0$mm";
                                }
                                selectedDate = '$mm-$year';
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
                                  UIHelper.titleTxtStyle(selectedDate.isNotEmpty ? selectedDate : "Select Month"),
                                ],
                              ),
                            ))),
                    UIHelper.verticalSpaceSmall,
                    IconButton(
                        onPressed: () async {
                          if (cusId.isNotEmpty && selectedDate.isNotEmpty) {
                            appController.getCompanytripList(selectedDate, cusId);
                          }
                        },
                        icon: Icon(size: 40, color: _colors.primarycolour, Icons.send_outlined)),
                  ],
                ),
                UIHelper.verticalSpaceSmall,
                Expanded(
                    child: appController.companytripsList.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: appController.companytripsList.length,
                            itemBuilder: (context, index) {
                              dynamic currentData = appController.companytripsList[index];
                              return cardData(index, currentData);
                            })
                        : Center(child: UIHelper.titleTxtStyle("Data not found")))
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget cardData(int index, dynamic currentData) {
    dynamic user = Utils().getDriverdetails("${currentData['driver_id']}");
    dynamic customer = Utils().getCustomerrdetails("${currentData['customer_id']}");
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, _colors.whiteColour, isShadow: true, shadowColor: _colors.primarycolour),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.titleTxtStyle(customer['name'], fntcolor: _colors.primarycolour, fntsize: 14, fntWeight: FontWeight.bold),
              UIHelper.titleTxtStyle("${currentData['pickup_time']} (to) ${currentData['drop_time']}", fntcolor: _colors.bluecolor, fntsize: 10, fntWeight: FontWeight.bold),
            ],
          ),
          Divider(color: _colors.greycolor1),
          Row(
            children: [
              UIHelper.titleTxtStyle(user['name'].toString().toUpperCase(), fntcolor: _colors.orangeColour, fntsize: 14, fntWeight: FontWeight.bold),
              UIHelper.titleTxtStyle(" - (${currentData['vehicle_no']})", fntcolor: _colors.textColour, fntsize: 12),
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20, color: _colors.bluecolor),
              UIHelper.horizontalSpaceTiny,
              UIHelper.titleTxtStyle("${currentData['pickup_place']} - ${currentData['drop_place']}", fntcolor: _colors.textColour, fntsize: 12),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  rowwidget1("Package Hour", "${currentData['total_hr']}"),
                  rowwidget1("Extra Km", "${currentData['extra_km']}"),
                  rowwidget("Toll Amount", "${currentData['toll_amt']}"),
                  rowwidget("Others", "${currentData['other_amount']}"),
                  rowwidget("Advance", "${currentData['advance_amt']}", txtClr: _colors.greenColour),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  rowwidget1("Total Km", "${currentData['km']}"),
                  rowwidget1("Extra Km", "${currentData['extra_km_amount']}"),
                  rowwidget("Driver Salary", "${currentData['driver_salary']}"),
                  rowwidget("Parking", "${currentData['parking']}"),
                ],
              )
            ],
          ),
          UIHelper.verticalSpaceSmall,
          currentData['description'].toString().isNotEmpty
              ? UIHelper.titleTxtStyle("${currentData['description']}", fntcolor: _colors.orangeColour, fntsize: 15, textOverflow: TextOverflow.visible)
              : const SizedBox(),
          Divider(color: _colors.primarycolour),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              rowwidget("Balance", "${currentData['balance_amount']}", txtClr: _colors.redColour),
              GestureDetector(
                onTap: () async {
                  await Get.toNamed(Routes.companyaddEditTrip, arguments: {"isedit": true, "initdata": currentData});
                  appController.getCompanytripList(selectedDate, cusId);
                },
                child: Container(
                  decoration: UIHelper.roundedBorderWithColor(15, 15, 15, 15, _colors.bluecolor),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: UIHelper.titleTxtStyle("Edit", fntcolor: _colors.whiteColour, fntWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget rowwidget(title, value, {Color txtClr = Colors.black}) {
    return Row(
      children: [
        UIHelper.titleTxtStyle("$title", fntcolor: _colors.greycolor, fntsize: 13),
        UIHelper.titleTxtStyle(" : ₹ $value", fntcolor: txtClr, fntsize: 13, fntWeight: FontWeight.bold),
      ],
    );
  }

  Widget rowwidget1(title, value, {Color txtClr = Colors.black}) {
    return Row(
      children: [
        UIHelper.titleTxtStyle("$title", fntcolor: _colors.greycolor, fntsize: 13),
        UIHelper.titleTxtStyle(" : $value", fntcolor: txtClr, fntsize: 13, fntWeight: FontWeight.bold),
      ],
    );
  }
}
