import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/static_datas.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';

class CompantTripScreen extends StatefulWidget {
  const CompantTripScreen({super.key});

  @override
  State<CompantTripScreen> createState() => CompantTripScreenState();
}

class CompantTripScreenState extends State<CompantTripScreen> {
  final AppColors _colors = AppColors();
  final PreferenceService pref = Get.find<PreferenceService>();
  bool isEdit = false;
  dynamic initdata = {};
  int selectedTypeid = 0;
  String vehiclenumber = "";
  String selectedDriverid = "";
  String customerName = "";
  String pickuppoint = "";
  String droppoint = "";
  String pickuptime = "";
  String droptime = "";
  String km = "";
  String tollAmt = "";
  String driversalarry = "";
  String parkingAmt = "";
  String advAmt = "";
  String othrAmt = "";
  String otherDesc = "";

  @override
  void initState() {
    super.initState();
    log("${pref.dutyDetails}");
    isEdit = Get.arguments['isedit'];
    if (isEdit) {
      initdata = Get.arguments['initdata'];

      vehiclenumber = initdata["vehicle_no"].toString();
      selectedDriverid = initdata["driver_id"].toString();
      customerName = initdata["customer_id"].toString();
      pickuppoint = initdata["pickup_place"].toString();
      droppoint = initdata["drop_place"].toString();
      pickuptime = initdata["pickup_time"].toString();
      droptime = initdata["drop_time"].toString();
      km = initdata['km'].toString();
      tollAmt = initdata["toll_amt"].toString();
      driversalarry = initdata["driver_salary"].toString();
      parkingAmt = initdata["parking"].toString();
      advAmt = initdata["advance_amt"].toString();
      othrAmt = initdata["other_amount"].toString();
      otherDesc = initdata["description"].toString();
    }
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
          title: UIHelper.titleTxtStyle(isEdit ? "Edit Company Trip" : "Start Company Trip", fntcolor: _colors.bgClr, fntsize: 22),
        ),
        body: SingleChildScrollView(child: page1()));
  }

  Widget page1() {
    return FormBuilder(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(2, (index) {
                  return GestureDetector(
                    onTap: () {
                      selectedTypeid = index;
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Icon(selectedTypeid == index ? Icons.radio_button_checked : Icons.radio_button_off),
                        UIHelper.horizontalSpaceTiny,
                        UIHelper.titleTxtStyle(index == 0 ? "Local" : "Out Station", fntsize: 15, fntWeight: selectedTypeid == index ? FontWeight.bold : FontWeight.normal),
                      ],
                    ),
                  );
                })),
            UIHelper.verticalSpaceSmall,
            CustomDropDown(
                initList: pref.customersList,
                initValue: customerName,
                hintText: "Customer Name",
                fieldname: "customer_id",
                onSelected: (val) {
                  customerName = val;
                  setState(() {});
                }),
            UIHelper.verticalSpaceSmall,
            CustomDatePicker(
                initValue: pickuptime,
                hintText: "Pickup Time",
                fieldname: "pickup_time",
                isTimeonly: true,
                onSelected: (val) {
                  pickuptime = val;
                  setState(() {});
                }),
            UIHelper.verticalSpaceSmall,
            CustomDatePicker(
                initValue: droptime,
                hintText: "Drop Time",
                fieldname: "drop_time",
                isTimeonly: true,
                onSelected: (val) {
                  droptime = val;
                  setState(() {});
                }),
            UIHelper.verticalSpaceSmall,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: CustomDropDown(
                        initList: pref.driversList,
                        initValue: selectedDriverid,
                        hintText: "Driver",
                        fieldname: "driver_id",
                        onSelected: (val) {
                          selectedDriverid = val;
                          setState(() {});
                        })),
                UIHelper.horizontalSpaceSmall,
                Expanded(
                    child: CustomDropDown(
                        initList: pref.carList,
                        initValue: vehiclenumber,
                        hintText: "Vehicle Number",
                        fieldname: "vehicle_no",
                        onSelected: (val) {
                          vehiclenumber = val;
                          setState(() {});
                        }))
              ],
            ),
            UIHelper.verticalSpaceSmall,
            UIHelper.titleTxtStyle("Other Details", fntcolor: _colors.primarycolour, fntsize: 18),
            UIHelper.verticalSpaceSmall,
            Row(
              children: [
                Expanded(
                    child: CustomInput(
                  hintText: "Pickup Location",
                  initValue: pickuppoint,
                  fieldname: "pickup_place",
                  fieldType: "novalidation",
                  onchanged: (val) {
                    pickuppoint = val;
                    setState(() {});
                  },
                )),
                UIHelper.horizontalSpaceSmall,
                Expanded(
                    child: CustomInput(
                  hintText: "Drop Location",
                  initValue: droppoint,
                  fieldname: "drop_place",
                  fieldType: "novalidation",
                  onchanged: (val) {
                    droppoint = val;
                    setState(() {});
                  },
                )),
              ],
            ),
            UIHelper.verticalSpaceSmall,
            CustomInput(
              hintText: "Kilometers",
              initValue: km,
              fieldname: "km",
              fieldType: "number",
              onchanged: (val) {
                km = val;
                setState(() {});
              },
            ),
            UIHelper.verticalSpaceSmall,
            CustomInput1(
              hintText: "Toll Amount",
              initValue: tollAmt,
              fieldname: "toll_amt",
              fieldType: "novalidation",
              onchanged: (val) {
                tollAmt = val;
                setState(() {});
              },
            ),
            UIHelper.verticalSpaceSmall,
            CustomInput1(
              hintText: "Driver Salary",
              initValue: driversalarry,
              fieldname: "driver_salary",
              fieldType: "novalidation",
              onchanged: (val) {
                driversalarry = val;
                setState(() {});
              },
            ),
            UIHelper.verticalSpaceSmall,
            CustomInput1(
              hintText: "Parking Amount",
              initValue: parkingAmt,
              fieldname: "parking",
              fieldType: "novalidation",
              onchanged: (val) {
                parkingAmt = val;
                setState(() {});
              },
            ),
            UIHelper.verticalSpaceSmall,
            CustomInput1(
              hintText: "Advance Amount",
              initValue: advAmt,
              fieldname: "advance_amt",
              fieldType: "novalidation",
              onchanged: (val) {
                advAmt = val;
                setState(() {});
              },
            ),
            UIHelper.verticalSpaceSmall,
            CustomInput1(
              hintText: "Other Amount",
              initValue: othrAmt,
              fieldname: "other_amount",
              fieldType: "novalidation",
              onchanged: (val) {
                othrAmt = val;
                setState(() {});
              },
            ),
            UIHelper.verticalSpaceSmall,
            CustomInput(
              hintText: "Other description",
              initValue: otherDesc,
              fieldname: "description",
              fieldType: "tect",
              onchanged: (val) {
                otherDesc = val;
                setState(() {});
              },
            ),
            UIHelper.verticalSpaceMedium,
            Center(
              child: UIHelper().actionButton("Next", 18, Get.width / 2, bgcolour: _colors.primarycolour, onPressed: () {
                if (customerName.isEmpty) {
                  Utils().showToast("Warning", "please enter the customer name", bgclr: _colors.orangeColour);
                }
                // else if (pickuptime.isEmpty && droptime.isEmpty) {
                //   Utils().showToast("Warning", "Time Details missing", bgclr: _colors.orangeColour);
                // } else if (vehiclenumber.isEmpty) {
                //   Utils().showToast("Warning", "please select Vehicle", bgclr: _colors.orangeColour);
                // } else if (selectedDriverid.isEmpty) {
                //   Utils().showToast("Warning", "please select Driver", bgclr: _colors.orangeColour);
                // } else if (pickuppoint.isEmpty && droppoint.isEmpty) {
                //   Utils().showToast("Warning", "Location Details missing", bgclr: _colors.orangeColour);
                // } else if (km.isEmpty) {
                //   Utils().showToast("Warning", "please Enter the over all Kilometers", bgclr: _colors.orangeColour);
                // } else if (driversalarry.isEmpty) {
                //   Utils().showToast("Warning", "please Enter Driver Salary", bgclr: _colors.orangeColour);
                // }
                else {
                  int hours = 0;
                  int days = 0;
                  if (selectedTypeid == 0) {
                    final format = DateFormat("dd-MM-yyyy hh:mm a");
                    DateTime dateTime1 = format.parse(droptime);
                    DateTime dateTime2 = format.parse(pickuptime);
                    Duration diff = dateTime1.difference(dateTime2);
                    hours = (diff.inMinutes / 60.0).round();
                  } else {
                    final format = DateFormat("dd-MM-yyyy");
                    DateTime dateTime1 = format.parse(droptime);
                    DateTime dateTime2 = format.parse(pickuptime);
                    days = (dateTime1.difference(dateTime2).inDays) + 1;
                    hours = days * 25;
                  }

                  if (hours < 1) {
                    Utils().showToast("Warning", "please Check the Droptime", bgclr: _colors.redColour);
                  } else {
                    Map<String, dynamic> reqData = dataparsefunction(hours, days);
                    if (isEdit) {
                      reqData['trip_id'] = initdata['_id'];
                      reqData['service_id'] = "edit_companytrip";
                      AppController().newCompanyTripStart(reqData);
                    } else {
                      reqData['service_id'] = "add_companytrip";
                      AppController().newCompanyTripStart(reqData);
                    }
                  }
                }
              }),
            )
          ],
        ),
      ),
    );
  }

  dataparsefunction(int hours, int days) {
    double onehrAmt = double.parse("${pref.dutyDetails['hr_amount']}");
    int hrKm = int.parse("${pref.dutyDetails['per_hr_km']}");
    double extrakmAmt = double.parse("${pref.dutyDetails['ex_km_amount']}");

    double packageAmount = hours * onehrAmt;
    int difKm = 0;
    int maxKm = hours * hrKm;
    if (maxKm < int.parse(km)) {
      difKm = int.parse(km) - maxKm;
    }

    double extraKmFinalAmt = difKm * extrakmAmt;

    double tollTodouble = tollAmt.isNotEmpty ? double.parse(tollAmt) : 0;
    double salaryTodouble = driversalarry.isNotEmpty ? double.parse(driversalarry) : 0;
    double parkingTodouble = parkingAmt.isNotEmpty ? double.parse(parkingAmt) : 0;
    double otheramtTodouble = othrAmt.isNotEmpty ? double.parse(othrAmt) : 0;
    double advanceTodouble = advAmt.isNotEmpty ? double.parse(advAmt) : 0;
    double balanceAmount = (packageAmount + extraKmFinalAmt + tollTodouble + salaryTodouble + parkingTodouble + otheramtTodouble) - advanceTodouble;

    Map<String, dynamic> postParams = {
      "type_id": selectedTypeid,
      "customer_id": customerName,
      "pickup_time": pickuptime,
      "drop_time": droptime,
      "vehicle_no": vehiclenumber,
      'driver_id': selectedDriverid,
      "pickup_place": pickuppoint,
      "drop_place": droppoint,
      "total_hr": selectedTypeid == 0 ? hours : (days * 24),
      "km": km,
      "extra_km": difKm,
      "package_amount": packageAmount,
      "extra_km_amount": extraKmFinalAmt,
      "toll_amt": tollTodouble,
      "driver_salary": salaryTodouble,
      "parking": parkingTodouble,
      "advance_amt": advanceTodouble,
      "other_amount": otheramtTodouble,
      "description": otherDesc,
      "balance_amount": balanceAmount
    };

    return postParams;
  }
}
