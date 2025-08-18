import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
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
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _page2key = GlobalKey<FormBuilderState>();

  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();
  final PreferenceService pref = Get.find<PreferenceService>();
  Map<String, dynamic> postParams = {};
  String selectedDriverid = "";
  int currentperform = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _colors.bgClr,
        appBar: AppBar(
          backgroundColor: _colors.primarycolour,
          centerTitle: true,
          iconTheme: IconThemeData(color: _colors.bgClr),
          title: UIHelper.titleTxtStyle("Start Trip", fntcolor: _colors.bgClr, fntsize: 22),
        ),
        body: SingleChildScrollView(child: currentperform == 1 ? page1() : page2()));
  }

  Widget page1() {
    return FormBuilder(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: CustomDatePicker(hintText: "Trip Date", fieldname: "trip_date", onSelected: (val) {})),
                UIHelper.horizontalSpaceSmall,
                Expanded(child: CustomDropDown(initList: pref.carList, hintText: "Vehicle Number", fieldname: "vehicle_no", onSelected: (val) {}))
              ],
            ),
            UIHelper.verticalSpaceMedium,
            UIHelper.titleTxtStyle("Select Driver", fntcolor: _colors.primarycolour, fntsize: 18),
            UIHelper.verticalSpaceSmall,
            SizedBox(
              height: 120,
              width: Get.width,
              child: ListView.builder(
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
                  }),
            ),
            UIHelper.verticalSpaceSmall,
            const Row(
              children: [
                Expanded(child: CustomInput(hintText: "OLA Cash", fieldname: "ola_cash", fieldType: "novalidation")),
                UIHelper.horizontalSpaceSmall,
                Expanded(child: CustomInput(hintText: "OLA Operator", fieldname: "ola_operator", fieldType: "novalidation")),
              ],
            ),
            UIHelper.verticalSpaceSmall,
            const Row(
              children: [
                Expanded(child: CustomInput(hintText: "Uber Cash", fieldname: "uber_cash", fieldType: "novalidation")),
                UIHelper.horizontalSpaceSmall,
                Expanded(child: CustomInput(hintText: "Uber Operator", fieldname: "uber_operator", fieldType: "novalidation")),
              ],
            ),
            UIHelper.verticalSpaceSmall,
            const Row(
              children: [
                Expanded(child: CustomInput(hintText: "Rapido Cash", fieldname: "rapido_cash", fieldType: "novalidation")),
                UIHelper.horizontalSpaceSmall,
                Expanded(child: CustomInput(hintText: "Rapido Operator", fieldname: "rapido_operator", fieldType: "novalidation")),
              ],
            ),
            UIHelper.verticalSpaceSmall,
            const CustomInput(hintText: "Others", fieldname: "other_cash", fieldType: "novalidation"),
            UIHelper.verticalSpaceMedium,
            Center(
              child: UIHelper().actionButton("Next", 18, Get.width / 2, bgcolour: _colors.primarycolour, onPressed: () {
                if (_formKey.currentState!.saveAndValidate()) {
                  if (selectedDriverid.isNotEmpty) {
                    postParams = Map.from(_formKey.currentState!.value);
                    postParams['service'] = "start_trip";
                    postParams['driver_id'] = selectedDriverid;
                    double olacash = postParams['ola_cash'].toString().isNotEmpty ? double.parse(postParams['ola_cash']) : 0.0;
                    double ubercash = postParams['uber_cash'].toString().isNotEmpty ? double.parse(postParams['uber_cash']) : 0.0;
                    double rapidocash = postParams['rapido_cash'].toString().isNotEmpty ? double.parse(postParams['rapido_cash']) : 0.0;
                    double othercash = postParams['other_cash'].toString().isNotEmpty ? double.parse(postParams['other_cash']) : 0.0;

                    double olaoperator = postParams['ola_operator'].toString().isNotEmpty ? double.parse(postParams['ola_operator']) : 0.0;
                    double uberoperator = postParams['uber_operator'].toString().isNotEmpty ? double.parse(postParams['uber_operator']) : 0.0;
                    double rapidoperator = postParams['rapido_operator'].toString().isNotEmpty ? double.parse(postParams['rapido_operator']) : 0.0;

                    postParams['amount_details'] = [
                      {"type": "OLA", "cash": olacash, "operator": olaoperator},
                      {"type": "Uber", "cash": ubercash, "operator": uberoperator},
                      {"type": "Rapido", "cash": rapidocash, "operator": rapidoperator},
                      {"type": "Others", "cash": othercash, "operator": ""},
                    ];

                    postParams['over_all_operator'] = olaoperator + uberoperator + rapidoperator;
                    postParams['over_all_cash'] = olacash + ubercash + rapidocash + othercash;

                    // currentperform = 2;
                    setState(() {});
                    log("$postParams");
                  }
                } else {
                  Utils().showAlert("W", "Please select the Driver");
                }
              }),
            )
          ],
        ),
      ),
    );
  }

  Widget page2() {
    return FormBuilder(
      key: _page2key,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UIHelper.verticalSpaceSmall,
            Container(
              padding: const EdgeInsets.all(15),
              decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, _colors.whiteColour, isShadow: true, shadowColor: _colors.primarycolour),
              child: Column(
                children: [
                  rowdata("Company", "Cash", "Operatot", true),
                  UIHelper.verticalSpaceSmall,
                  Column(
                    children: List.generate(postParams['amount_details'].length, (index) {
                      dynamic data = postParams['amount_details'][index];
                      return rowdata("${data['type']}", "${data['cash']}", "${data['operator']}", false);
                    }),
                  ),
                  const Divider(),
                  rowdata("Total", "${postParams['over_all_cash']}", "${postParams['over_all_operator']}", true),
                ],
              ),
            ),
            UIHelper.titleTxtStyle("${postParams['over_all_operator']}", fntcolor: _colors.primarycolour, fntsize: 18, textOverflow: TextOverflow.visible),
            // Center(
            //   child: UIHelper().actionButton("Next", 18, Get.width / 2, bgcolour: _colors.primarycolour, onPressed: () {
            //     // if (_page2key.currentState!.saveAndValidate()) {
            //     //    Map<String, dynamic> postParams = Map.from(_page2key.currentState!.value);
            //     //   log("$postParams");
            //     // }
            //   }),
            // )
          ],
        ),
      ),
    );
  }

  Widget rowdata(String t1, String t2, String t3, bool isheading) {
    return Row(
      children: [
        Expanded(flex: 2, child: UIHelper.titleTxtStyle(t1, fntsize: 14, fntWeight: isheading ? FontWeight.bold : FontWeight.normal)),
        Expanded(flex: 2, child: UIHelper.titleTxtStyle(t2, fntsize: 14, fntWeight: isheading ? FontWeight.bold : FontWeight.normal)),
        Expanded(flex: 2, child: UIHelper.titleTxtStyle(t3, fntsize: 14, fntWeight: isheading ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
