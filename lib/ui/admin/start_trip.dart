import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';

class StartTripScreen extends StatefulWidget {
  const StartTripScreen({super.key});

  @override
  State<StartTripScreen> createState() => _StartTripScreenState();
}

class _StartTripScreenState extends State<StartTripScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final AppColors _colors = AppColors();

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
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                CustomDatePicker(hintText: "Trip Date", fieldname: "trip_date", onSelected: (val) {}),
                UIHelper.verticalSpaceSmall,
                CustomDropDown(initList: const [], hintText: "Vehicle Number", fieldname: "vehicle_no", onSelected: (val) {}),
                UIHelper.verticalSpaceSmall,
                CustomDropDown(initList: const [], hintText: "Driver", fieldname: "driver_id", onSelected: (val) {}),
                UIHelper.verticalSpaceSmall,
                const CustomInput(hintText: "OLA Operatoe", fieldname: "", fieldType: "novalidation"),
                UIHelper.verticalSpaceSmall,
                const CustomInput(hintText: "OLA Cash", fieldname: "", fieldType: "novalidation"),
                UIHelper.verticalSpaceSmall,
                const CustomInput(hintText: "Uber Operator", fieldname: "", fieldType: "novalidation"),
                UIHelper.verticalSpaceSmall,
                const CustomInput(hintText: "Uber Cash", fieldname: "", fieldType: "novalidation"),
                UIHelper.verticalSpaceSmall,
                const CustomInput(hintText: "Rapido", fieldname: "", fieldType: "novalidation"),
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
      ),
    );
  }
}
