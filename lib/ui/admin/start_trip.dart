import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';

class StartTripScreen extends StatefulWidget {
  const StartTripScreen({super.key});

  @override
  State<StartTripScreen> createState() => _StartTripScreenState();
}

class _StartTripScreenState extends State<StartTripScreen> {
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();
  final PreferenceService pref = Get.find<PreferenceService>();
  bool isEdit = false;
  dynamic initdata = {};

  String tripDate = "";
  String vehiclenumber = "";
  String selectedDriverid = "";
  String olacash = "", olaoperator = "";
  String ubercash = "", uberoperator = "";
  String rapidocash = "", rapidooperator = "";
  String othercash = "", otheroperator = "";
  String salaryPercentage = "";
  String fuel = "";
  String otherexp = "";
  String otherdesc = "";
  String kilometer = "";

  double overAllCashAmt = 0.0;
  double overAllOperatorAmt = 0.0;

  @override
  void initState() {
    super.initState();
    isEdit = Get.arguments['isedit'];
    if (isEdit) {
      initdata = Get.arguments['initdata'];
      log("initdata $initdata ");

      tripDate = initdata["trip_date"].toString();
      vehiclenumber = initdata["vehicle_no"].toString();
      selectedDriverid = initdata["driver_id"].toString();
      olacash = initdata["ola_cash"].toString();
      olaoperator = initdata["ola_operator"].toString();
      ubercash = initdata["uber_cash"].toString();
      uberoperator = initdata["uber_operator"].toString();
      rapidocash = initdata["rapido_cash"].toString();
      rapidooperator = initdata["rapido_operator"].toString();
      othercash = initdata["other_cash"].toString();
      otheroperator = initdata["other_operator"].toString();
      salaryPercentage = initdata["salary_percentage"].toString();
      fuel = initdata["fuel_amt"].toString();
      otherexp = initdata["other_expences"].toString();
      otherdesc = initdata["other_desc"].toString();
      kilometer = initdata["kilometer"].toString();
      overAllCashAmt = double.parse(initdata["total_cash_amt"].toString());
      overAllOperatorAmt = double.parse(initdata["total_operator_amt"].toString());
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
          title: UIHelper.titleTxtStyle(isEdit ? "Edit Trip" : "Start Trip", fntcolor: _colors.bgClr, fntsize: 22),
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
            UIHelper.verticalSpaceMedium,
            UIHelper.titleTxtStyle("Select Driver", fntcolor: _colors.primarycolour, fntsize: 18),
            UIHelper.verticalSpaceSmall,
            SizedBox(
              height: 120,
              width: Get.width,
              child: pref.driversList.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: pref.driversList.length,
                      itemBuilder: (context, index) {
                        dynamic currentData = pref.driversList[index];
                        return InkWell(
                          onTap: () {
                            selectedDriverid = currentData['_id'].toString();
                            setState(() {});
                          },
                          child: Container(
                              margin: const EdgeInsets.all(5),
                              width: 100,
                              padding: const EdgeInsets.all(5),
                              decoration: UIHelper.roundedBorderWithColor(10, 10, 10, 10, _colors.whiteColour,
                                  borderColor: selectedDriverid == currentData['_id'].toString() ? _colors.primarycolour : _colors.greycolor1,
                                  borderWidth: selectedDriverid == currentData['_id'].toString() ? 2 : 1),
                              child: Column(
                                children: [
                                  UIHelper.verticalSpaceSmall,
                                  currentData['imgurl'] != null
                                      ? CircleAvatar(
                                          radius: 25,
                                          backgroundColor: _colors.primarycolour,
                                          backgroundImage: NetworkImage("${ApiServices().apiurl}/${currentData['imgurl']}"),
                                        )
                                      : Image.asset(_images.profile, height: 50, width: 50),
                                  UIHelper.verticalSpaceSmall,
                                  UIHelper.titleTxtStyle(currentData['name'], fntcolor: _colors.primarycolour, fntsize: 12),
                                ],
                              )),
                        );
                      })
                  : UIHelper.titleTxtStyle("Driver List is empty.", fntcolor: _colors.redColour, fntsize: 12),
            ),
            UIHelper.verticalSpaceSmall,
            UIHelper.titleTxtStyle("Amount Details", fntcolor: _colors.primarycolour, fntsize: 18),
            UIHelper.verticalSpaceSmall,
            Row(
              children: [
                Expanded(
                    child: CustomInput1(
                  hintText: "OLA Cash",
                  initValue: olacash,
                  fieldname: "ola_cash",
                  fieldType: "novalidation",
                  onchanged: (val) {
                    olacash = val;
                    setState(() {});
                    amountcalculate();
                  },
                )),
                UIHelper.horizontalSpaceSmall,
                Expanded(
                    child: CustomInput1(
                  hintText: "OLA Operator",
                  initValue: olaoperator,
                  fieldname: "ola_operator",
                  fieldType: "novalidation",
                  onchanged: (val) {
                    olaoperator = val;
                    setState(() {});
                    amountcalculate();
                  },
                )),
              ],
            ),
            UIHelper.verticalSpaceSmall,
            Row(
              children: [
                Expanded(
                    child: CustomInput1(
                  hintText: "Uber Cash",
                  initValue: ubercash,
                  fieldname: "uber_cash",
                  fieldType: "novalidation",
                  onchanged: (val) {
                    ubercash = val;
                    setState(() {});
                    amountcalculate();
                  },
                )),
                UIHelper.horizontalSpaceSmall,
                Expanded(
                    child: CustomInput1(
                  hintText: "Uber Operator",
                  initValue: uberoperator,
                  fieldname: "uber_operator",
                  fieldType: "novalidation",
                  onchanged: (val) {
                    uberoperator = val;
                    setState(() {});
                    amountcalculate();
                  },
                )),
              ],
            ),
            UIHelper.verticalSpaceSmall,
            Row(
              children: [
                Expanded(
                    child: CustomInput1(
                  hintText: "Rapido Cash",
                  initValue: rapidocash,
                  fieldname: "rapido_cash",
                  fieldType: "novalidation",
                  onchanged: (val) {
                    rapidocash = val;
                    setState(() {});
                    amountcalculate();
                  },
                )),
                UIHelper.horizontalSpaceSmall,
                Expanded(
                    child: CustomInput1(
                  hintText: "Rapido Operator",
                  initValue: rapidooperator,
                  fieldname: "rapido_operator",
                  fieldType: "novalidation",
                  onchanged: (val) {
                    rapidooperator = val;
                    setState(() {});
                    amountcalculate();
                  },
                )),
              ],
            ),
            UIHelper.verticalSpaceSmall,
            Row(
              children: [
                Expanded(
                    child: CustomInput1(
                  hintText: "Others Cash",
                  initValue: othercash,
                  fieldname: "other_cash",
                  fieldType: "novalidation",
                  onchanged: (val) {
                    othercash = val;
                    setState(() {});
                    amountcalculate();
                  },
                )),
                UIHelper.horizontalSpaceSmall,
                Expanded(
                    child: CustomInput1(
                  hintText: "Others Operator",
                  initValue: otheroperator,
                  fieldname: "other_operator",
                  fieldType: "novalidation",
                  onchanged: (val) {
                    otheroperator = val;
                    setState(() {});
                    amountcalculate();
                  },
                )),
              ],
            ),
            UIHelper.verticalSpaceSmall,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                UIHelper.titleTxtStyle("Total : $overAllCashAmt", fntsize: 14, fntWeight: FontWeight.w600),
                UIHelper.titleTxtStyle("Total : $overAllOperatorAmt", fntsize: 14, fntWeight: FontWeight.w600),
              ],
            ),
            Divider(color: _colors.bluecolor),
            UIHelper.verticalSpaceSmall,
            UIHelper.titleTxtStyle("Kilometer Details", fntcolor: _colors.primarycolour, fntsize: 18),
            UIHelper.verticalSpaceSmall,
            CustomInput1(
              hintText: "Kilometer",
              initValue: kilometer,
              fieldname: "kilometer",
              fieldType: "number",
              onchanged: (val) {
                kilometer = val;
                setState(() {});
              },
            ),
            UIHelper.verticalSpaceSmall,
            UIHelper.verticalSpaceSmall,
            UIHelper.titleTxtStyle("Expences Details", fntcolor: _colors.primarycolour, fntsize: 18),
            UIHelper.verticalSpaceSmall,
            CustomInput1(
              hintText: "Driver Salary",
              initValue: salaryPercentage,
              fieldname: "salary_perentage",
              fieldType: "salary",
              onchanged: (val) {
                salaryPercentage = val;
                setState(() {});
              },
            ),
            UIHelper.verticalSpaceSmall,
            CustomInput1(
              hintText: "Fuel",
              fieldname: "fuel_amt",
              initValue: fuel,
              fieldType: "fuel",
              onchanged: (val) {
                fuel = val;
                setState(() {});
              },
            ),
            UIHelper.verticalSpaceSmall,
            CustomInput1(
              hintText: "Others Expences",
              fieldname: "other_expences",
              initValue: otherexp,
              fieldType: "other_expences",
              onchanged: (val) {
                otherexp = val;
                setState(() {});
              },
            ),
            UIHelper.verticalSpaceSmall,
            CustomInput(
              hintText: "Others Description",
              fieldname: "other_description",
              initValue: otherdesc,
              fieldType: "novalidation",
              onchanged: (val) {
                otherdesc = val;
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
                } else if (overAllCashAmt < 1 || overAllOperatorAmt < 1) {
                  Utils().showToast("Warning", "Amount Details missing", bgclr: _colors.orangeColour);
                } else if (kilometer.isEmpty) {
                  Utils().showToast("Warning", "please Enter the Kilometers", bgclr: _colors.orangeColour);
                } else if (salaryPercentage.isEmpty) {
                  Utils().showToast("Warning", "please Enter the salary percentage", bgclr: _colors.orangeColour);
                } else {
                  Map<String, dynamic> reqData = dataparsefunction();
                  if (isEdit) {
                    reqData['service_id'] = "edit_trip";
                    reqData['trip_id'] = initdata['_id'];
                  } else {
                    reqData['service_id'] = "new_trip";
                  }
                  AppController().newTripStart(reqData);
                }
              }),
            )
          ],
        ),
      ),
    );
  }

  amountcalculate() {
    double olacash_ = olacash.isNotEmpty ? double.parse(olacash) : 0.0;
    double ubercash_ = ubercash.isNotEmpty ? double.parse(ubercash) : 0.0;
    double rapidocash_ = rapidocash.isNotEmpty ? double.parse(rapidocash) : 0.0;
    double othercash_ = othercash.isNotEmpty ? double.parse(othercash) : 0.0;

    double olaoperator_ = olaoperator.isNotEmpty ? double.parse(olaoperator) : 0.0;
    double uberoperator_ = uberoperator.isNotEmpty ? double.parse(uberoperator) : 0.0;
    double rapidoperator_ = rapidooperator.isNotEmpty ? double.parse(rapidooperator) : 0.0;
    double otheroperator_ = otheroperator.isNotEmpty ? double.parse(otheroperator) : 0.0;

    overAllOperatorAmt = olaoperator_ + uberoperator_ + rapidoperator_ + otheroperator_;
    overAllCashAmt = olacash_ + ubercash_ + rapidocash_ + othercash_;
    setState(() {});
  }

  dataparsefunction() {
    double fuelamt = fuel.isNotEmpty ? double.parse(fuel) : 0.0;
    double otherexpenceAmt = otherexp.isNotEmpty ? double.parse(otherexp) : 0.0;

    int salaryPercent = int.parse(salaryPercentage);
    double driversalary = salaryPercent / 100 * overAllOperatorAmt;
    double roundedSalary = (driversalary * 100).roundToDouble() / 100;
    double balanceamount = overAllCashAmt - roundedSalary - fuelamt - otherexpenceAmt;

    int kminteger = int.parse(kilometer);
    double perkmamt = overAllOperatorAmt / kminteger;

    Map<String, dynamic> postParams = {
      "trip_date": tripDate,
      "vehicle_no": vehiclenumber,
      'driver_id': selectedDriverid,
      "ola_cash": olacash,
      "ola_operator": olaoperator,
      "uber_cash": ubercash,
      "uber_operator": uberoperator,
      "rapido_cash": rapidocash,
      "rapido_operator": rapidooperator,
      "other_cash": othercash,
      "other_operator": otheroperator,
      "total_cash_amt": overAllCashAmt,
      "total_operator_amt": overAllOperatorAmt,
      "salary_percentage": salaryPercentage,
      "driver_salary": roundedSalary,
      "fuel_amt": fuelamt,
      "other_expences": otherexp,
      "other_desc": otherdesc,
      "kilometer": kilometer,
      "balance_amount": balanceamount,
      "per_km": (perkmamt * 100).roundToDouble() / 100,
    };
    return postParams;
  }
}
