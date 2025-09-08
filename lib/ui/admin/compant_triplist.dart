import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
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
    return Scaffold(
      backgroundColor: _colors.bgClr,
      appBar: AppBar(
        backgroundColor: _colors.primarycolour,
        centerTitle: true,
        iconTheme: IconThemeData(color: _colors.bgClr),
        title: UIHelper.titleTxtStyle("Company Trip List", fntcolor: _colors.bgClr, fntsize: 22),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            final controller = AppController();
            Future.delayed(const Duration(seconds: 1), () {
              controller.getCompanytripList(selectedDate);
            });
            return controller;
          })
        ],
        child: Consumer<AppController>(builder: (context, ref, child) {
          appController = ref;
          return Container(
            padding: const EdgeInsets.all(10),
            height: Get.height,
            width: Get.width,
            child: Column(
              children: [
                Row(
                  children: [
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
                                appController.getCompanytripList(selectedDate);
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
                    UIHelper.horizontalSpaceSmall,
                    IconButton(
                        onPressed: () async {
                          await Get.toNamed(Routes.companyaddEditTrip, arguments: {"isedit": false});
                          appController.getCompanytripList(selectedDate);
                        },
                        icon: Icon(size: 40, color: _colors.primarycolour, Icons.add_circle_outlined)),
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
          );
        }),
      ),
    );
  }

  Widget cardData(int index, dynamic currentData) {
    dynamic user = Utils().getDriverdetails("${currentData['driver_id']}");

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
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
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTxtStyle("Customer: ${currentData['customer_name']}", fntcolor: _colors.orangeColour, fntsize: 12, fntWeight: FontWeight.bold),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTxtStyle("${currentData['pickup_place']} - ${currentData['drop_place']}", fntcolor: _colors.textColour, fntsize: 12),
                      UIHelper.verticalSpaceTiny,
                      UIHelper.titleTxtStyle("Amount : ₹ ${currentData['amount']}", fntcolor: _colors.redColour, fntsize: 14, fntWeight: FontWeight.bold),
                    ],
                  )
                ],
              ),
              UIHelper.verticalSpaceSmall,
              GestureDetector(
                onTap: () async {
                  await Get.toNamed(Routes.companyaddEditTrip, arguments: {"isedit": true, "initdata": currentData});
                  appController.getCompanytripList(selectedDate);
                },
                child: Container(
                  decoration: UIHelper.roundedBorderWithColor(15, 15, 15, 15, _colors.greycolor1),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: UIHelper.titleTxtStyle("Edit", fntWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        Positioned(
            right: 20,
            top: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                UIHelper.titleTxtStyle("${currentData['trip_date']}", fntcolor: _colors.bluecolor, fntsize: 12, fntWeight: FontWeight.bold),
                UIHelper.titleTxtStyle("${currentData['pickup_time']} ${currentData['pickup_sf']} - ${currentData['drop_time']} ${currentData['drop_sf']}",
                    fntcolor: _colors.bluecolor, fntsize: 10, fntWeight: FontWeight.bold),
              ],
            ))
      ],
    );
  }
}
