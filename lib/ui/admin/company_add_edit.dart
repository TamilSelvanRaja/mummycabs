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
  final AppImages _images = AppImages();
  final PreferenceService pref = Get.find<PreferenceService>();
  bool isEdit = false;
  dynamic initdata = {};

  String tripDate = "";
  String vehiclenumber = "";
  String selectedDriverid = "";
  String customerName = "";
  String pickuppoint = "";
  String droppoint = "";
  String pickuptime = "";
  String droptime = "";
  String amount = "";
  String tollAmt = "";
  String driversalarry = "";
  String parkingAmt = "";
  String advAmt = "";
  String othrAmt = "";
  String otherDesc = "";

  @override
  void initState() {
    super.initState();
    isEdit = Get.arguments['isedit'];
    if (isEdit) {
      initdata = Get.arguments['initdata'];

      tripDate = initdata["trip_date"].toString();
      vehiclenumber = initdata["vehicle_no"].toString();
      selectedDriverid = initdata["driver_id"].toString();
      customerName = initdata["customer_id"].toString();
      pickuppoint = initdata["pickup_place"].toString();
      droppoint = initdata["drop_place"].toString();
      pickuptime = initdata["pickup_time"].toString();
      droptime = initdata["drop_time"].toString();
      amount = initdata["amount"].toString();
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: CustomDatePicker(
                        initValue: tripDate,
                        hintText: "Trip Date",
                        fieldname: "trip_date",
                        onSelected: (val) {
                          tripDate = val;
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
            CustomDropDown(
                initList: pref.driversList,
                initValue: selectedDriverid,
                hintText: "Driver",
                fieldname: "driver_id",
                onSelected: (val) {
                  selectedDriverid = val;
                  setState(() {});
                }),
            // UIHelper.verticalSpaceMedium,
            // UIHelper.titleTxtStyle("Select Driver", fntcolor: _colors.primarycolour, fntsize: 18),
            // UIHelper.verticalSpaceSmall,
            // SizedBox(
            //   height: 120,
            //   width: Get.width,
            //   child: pref.driversList.isNotEmpty
            //       ? ListView.builder(
            //           scrollDirection: Axis.horizontal,
            //           itemCount: pref.driversList.length,
            //           itemBuilder: (context, index) {
            //             dynamic currentData = pref.driversList[index];
            //             return InkWell(
            //               onTap: () {
            //                 selectedDriverid = currentData['_id'].toString();
            //                 setState(() {});
            //               },
            //               child: Container(
            //                   margin: const EdgeInsets.all(5),
            //                   width: 100,
            //                   padding: const EdgeInsets.all(5),
            //                   decoration: UIHelper.roundedBorderWithColor(10, 10, 10, 10, _colors.whiteColour,
            //                       borderColor: selectedDriverid == currentData['_id'].toString() ? _colors.primarycolour : _colors.greycolor1,
            //                       borderWidth: selectedDriverid == currentData['_id'].toString() ? 2 : 1),
            //                   child: Column(
            //                     children: [
            //                       UIHelper.verticalSpaceSmall,
            //                       currentData['imgurl'] != null
            //                           ? CircleAvatar(
            //                               radius: 25,
            //                               backgroundColor: _colors.primarycolour,
            //                               backgroundImage: NetworkImage("${ApiServices().apiurl}/${currentData['imgurl']}"),
            //                             )
            //                           : Image.asset(_images.profile, height: 50, width: 50),
            //                       UIHelper.verticalSpaceSmall,
            //                       UIHelper.titleTxtStyle(currentData['name'], fntcolor: _colors.primarycolour, fntsize: 12),
            //                     ],
            //                   )),
            //             );
            //           })
            //       : UIHelper.titleTxtStyle("Driver List is empty.", fntcolor: _colors.redColour, fntsize: 12),
            // ),
            UIHelper.verticalSpaceSmall,
            UIHelper.titleTxtStyle("Other Details", fntcolor: _colors.primarycolour, fntsize: 18),
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
            Row(
              children: [
                Expanded(
                    child: CustomDatePicker(
                        initValue: pickuptime,
                        hintText: "Pickup Time",
                        fieldname: "pickup_time",
                        isTimeonly: true,
                        onSelected: (val) {
                          pickuptime = val;
                          setState(() {});
                        })),
                UIHelper.horizontalSpaceSmall,
                Expanded(
                    child: CustomDatePicker(
                        initValue: droptime,
                        hintText: "Drop Time",
                        fieldname: "drop_time",
                        isTimeonly: true,
                        onSelected: (val) {
                          droptime = val;
                          setState(() {});
                        })),
              ],
            ),
            UIHelper.verticalSpaceSmall,
            CustomInput1(
              hintText: "Premium Amount",
              initValue: amount,
              fieldname: "amount",
              fieldType: "novalidation",
              onchanged: (val) {
                amount = val;
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
                if (tripDate.isEmpty) {
                  Utils().showToast("Warning", "please select Trip date", bgclr: _colors.orangeColour);
                } else if (vehiclenumber.isEmpty) {
                  Utils().showToast("Warning", "please select Vehicle", bgclr: _colors.orangeColour);
                } else if (selectedDriverid.isEmpty) {
                  Utils().showToast("Warning", "please select Driver", bgclr: _colors.orangeColour);
                } else if (customerName.isEmpty) {
                  Utils().showToast("Warning", "please enter the customer name", bgclr: _colors.orangeColour);
                } else if (pickuppoint.isEmpty && droppoint.isEmpty) {
                  Utils().showToast("Warning", "Location Details missing", bgclr: _colors.orangeColour);
                } else if (pickuptime.isEmpty && droptime.isEmpty) {
                  Utils().showToast("Warning", "Time Details missing", bgclr: _colors.orangeColour);
                } else if (amount.isEmpty) {
                  Utils().showToast("Warning", "please Enter the amount", bgclr: _colors.orangeColour);
                } else if (driversalarry.isEmpty) {
                  Utils().showToast("Warning", "please Enter Driver Salary", bgclr: _colors.orangeColour);
                } else {
                  Map<String, dynamic> reqData = dataparsefunction();
                  if (isEdit) {
                    reqData['trip_id'] = initdata['_id'];
                    reqData['service_id'] = "edit_companytrip";
                    AppController().newCompanyTripStart(reqData);
                  } else {
                    reqData['service_id'] = "add_companytrip";
                    AppController().newCompanyTripStart(reqData);
                  }
                }
              }),
            )
          ],
        ),
      ),
    );
  }

  dataparsefunction() {
    double premiumamtTodouble = double.parse(amount);
    double tollTodouble = tollAmt.isNotEmpty ? double.parse(tollAmt) : 0;
    double salaryTodouble = driversalarry.isNotEmpty ? double.parse(driversalarry) : 0;
    double parkingTodouble = parkingAmt.isNotEmpty ? double.parse(parkingAmt) : 0;
    double otheramtTodouble = othrAmt.isNotEmpty ? double.parse(othrAmt) : 0;
    double advanceTodouble = advAmt.isNotEmpty ? double.parse(advAmt) : 0;
    double balanceAmount = (premiumamtTodouble + tollTodouble + salaryTodouble + parkingTodouble + otheramtTodouble) - advanceTodouble;
    Map<String, dynamic> postParams = {
      "trip_date": tripDate,
      "vehicle_no": vehiclenumber,
      'driver_id': selectedDriverid,
      "customer_id": customerName,
      "pickup_place": pickuppoint,
      "drop_place": droppoint,
      "pickup_time": pickuptime,
      "drop_time": droptime,
      "amount": amount,
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
