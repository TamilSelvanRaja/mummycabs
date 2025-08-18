import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';
import 'package:provider/provider.dart';

class CarDetailsScreen extends StatefulWidget {
  const CarDetailsScreen({super.key});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final AppColors _colors = AppColors();
  late AppController appController;
  final PreferenceService pref = Get.find<PreferenceService>();
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  String searchKey = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      appBar: AppBar(
        backgroundColor: _colors.primarycolour,
        centerTitle: true,
        iconTheme: IconThemeData(color: _colors.bgClr),
        title: UIHelper.titleTxtStyle("Car's Detail", fntcolor: _colors.bgClr, fntsize: 22),
      ),
      body: MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => AppController())],
        child: Consumer<AppController>(builder: (context, ref, child) {
          appController = ref;
          return Column(
            children: [
              Container(
                height: 50,
                width: Get.width,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 5),
                child: Row(
                  children: [
                    Expanded(
                        child: CustomInput(
                      hintText: "Search name or register number",
                      fieldname: "search",
                      fieldType: "novalidation",
                      prefixWidget: const Icon(Icons.search),
                      onchanged: (val) {
                        searchKey = val.toString();
                        setState(() {});
                      },
                    )),
                    IconButton(
                        onPressed: () {
                          showCarAddDialog();
                        },
                        icon: Icon(size: 40, color: _colors.primarycolour, Icons.add_circle_outlined)),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: pref.carList.length,
                    itemBuilder: (context, index) {
                      dynamic currentData = pref.carList[index];
                      String isactive = currentData['active_flag'].toString();
                      return currentData['car_name'].toString().toLowerCase().contains(searchKey.toLowerCase()) || currentData['reg_no'].toString().toLowerCase().contains(searchKey.toLowerCase())
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(flex: 1, child: UIHelper.titleTxtStyle("${index + 1}", fntsize: 14)),
                                    Expanded(flex: 3, child: UIHelper.titleTxtStyle(currentData['car_name'], fntsize: 14)),
                                    Expanded(flex: 2, child: UIHelper.titleTxtStyle(currentData['reg_no'], fntsize: 14)),
                                    Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                            onTap: () {
                                              Utils().showAlert("De", "Do you want to ${isactive == "1" ? "deactive" : "activate"}?", subTitle: isactive == "1" ? "Deactivate" : "Activate",
                                                  onComplete: () {
                                                Map<String, dynamic> postParams = {'service_id': "car_deactive", "_id": currentData['_id'], "active_flag": isactive == "1" ? 0 : 1};
                                                appController.deactivatecar(postParams);
                                              });
                                            },
                                            child: isactive == "1" ? Icon(Icons.check, color: _colors.greenColour) : Icon(Icons.close, color: _colors.redColour))),
                                  ],
                                ),
                                const Divider()
                              ],
                            )
                          : const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future showCarAddDialog() async {
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
                            Expanded(child: UIHelper.titleTxtStyle("Add New Car", fntcolor: _colors.bgClr, fntsize: 18)),
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
                            const CustomInput(hintText: "Car Name", fieldname: "car_name", fieldType: "car_name"),
                            UIHelper.verticalSpaceSmall,
                            const CustomInput(hintText: "Register Number", fieldname: "reg_no", fieldType: "reg_no"),
                            UIHelper.verticalSpaceMedium,
                            UIHelper().actionButton("Submit", 14, Get.width / 3, onPressed: () {
                              if (_formkey.currentState!.saveAndValidate()) {
                                Map<String, dynamic> postParams = Map.from(_formkey.currentState!.value);
                                postParams['service_id'] = "add_new_car";
                                appController.newaddcar(postParams);
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
