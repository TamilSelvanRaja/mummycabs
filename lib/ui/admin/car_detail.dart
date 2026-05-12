import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/utils.dart';
import 'package:mummy_cabs/ui/widgets/custom_header.dart';
import 'package:provider/provider.dart';

class CarDetailsScreen extends StatefulWidget {
  const CarDetailsScreen({super.key});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final AppColors _colors = AppColors();
  late AppController appController;

  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  String searchKey = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, Colors.transparent, borderColor: _colors.primarycolour),
          width: Utils().getWidgetWidth(context) / 2,
          child: MultiProvider(
            providers: [ChangeNotifierProvider(create: (_) => AppController())],
            child: Consumer<AppController>(builder: (context, ref, child) {
              appController = ref;
              appController.initialize();
              return Column(
                children: [
                  CustomHeader(title: "Car Details"),
                  Container(
                    height: 50,
                    width: Utils().getWidgetWidth(context),
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
                              showCarAddDialog(false, {});
                            },
                            icon: Icon(size: 40, color: _colors.primarycolour, Icons.add_circle_outlined)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: ListView.builder(
                        itemCount: appController.admin_carList.length,
                        itemBuilder: (context, index) {
                          dynamic currentData = appController.admin_carList[index];
                          String isactive = currentData['active_flag'].toString();
                          return currentData['car_name'].toString().toLowerCase().contains(searchKey.toLowerCase()) || currentData['reg_no'].toString().toLowerCase().contains(searchKey.toLowerCase())
                              ? Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(flex: 1, child: UIHelper.titleTxtStyle("${index + 1}", fntsize: 14)),
                                        Expanded(flex: 3, child: UIHelper.titleTxtStyle(currentData['car_name'].toString().toUpperCase(), fntsize: 14)),
                                        Expanded(flex: 2, child: UIHelper.titleTxtStyle(currentData['reg_no'].toString().toUpperCase(), fntsize: 14)),
                                        GestureDetector(
                                            onTap: () {
                                              Utils().showAlert(context, "De", "Do you want to ${isactive == "1" ? "deactive" : "activate"}?", subTitle: isactive == "1" ? "Deactivate" : "Activate",
                                                  onComplete: () {
                                                Map<String, dynamic> postParams = {'service_id': "car_deactive", "_id": currentData['_id'], "active_flag": isactive == "1" ? 0 : 1};
                                                appController.deactivatecar(context, postParams);
                                              });
                                            },
                                            child: isactive == "1" ? Icon(Icons.check, color: _colors.greenColour) : Icon(Icons.close, color: _colors.redColour)),
                                        IconButton(
                                            onPressed: () {
                                              showCarAddDialog(true, currentData);
                                            },
                                            icon: Icon(size: 20, color: _colors.primarycolour, Icons.edit)),
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
        ),
      ),
    );
  }

  Future showCarAddDialog(bool isEdit, dynamic cardata) async {
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
                            Expanded(child: UIHelper.titleTxtStyle(isEdit ? "Edit car details" : "Add New Car", fntcolor: _colors.bgClr, fntsize: 18)),
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
                            CustomInput(hintText: "Car Name", initValue: !isEdit ? "" : cardata['car_name'], fieldname: "car_name", fieldType: "car_name"),
                            UIHelper.verticalSpaceSmall,
                            CustomInput(hintText: "Register Number", initValue: !isEdit ? "" : cardata['reg_no'], fieldname: "reg_no", fieldType: "reg_no"),
                            UIHelper.verticalSpaceMedium,
                            CustomInput(hintText: "Rent Amount", initValue: !isEdit ? "" : cardata['rent_amount'], fieldname: "rental_amount", fieldType: "rental_amount"),
                            UIHelper.verticalSpaceMedium,
                            UIHelper().actionButton(isEdit ? "Update" : "Submit", 16, Utils().getWidgetWidth(context) / 3, onPressed: () {
                              if (_formkey.currentState!.saveAndValidate()) {
                                Map<String, dynamic> postParams = Map.from(_formkey.currentState!.value);
                                if (isEdit) {
                                  postParams['service_id'] = "car_update";
                                  postParams['_id'] = cardata['_id'];
                                  appController.newaddcar(context, postParams);
                                } else {
                                  postParams['service_id'] = "add_new_car";
                                  appController.newaddcar(context, postParams);
                                }
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
}
