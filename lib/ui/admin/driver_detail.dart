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
import 'package:provider/provider.dart';

class DriverDetailsScreen extends StatefulWidget {
  const DriverDetailsScreen({super.key});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();
  final PreferenceService pref = Get.find<PreferenceService>();
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  late AppController appController;
  List selectedIndex = [];
  String searchKey = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      appBar: AppBar(
        backgroundColor: _colors.primarycolour,
        centerTitle: true,
        iconTheme: IconThemeData(color: _colors.bgClr),
        title: UIHelper.titleTxtStyle("Drivers Details", fntcolor: _colors.bgClr, fntsize: 22),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            final controller = AppController();
            Future.delayed(const Duration(milliseconds: 600), () {
              controller.getcarList("drivers_list");
            });
            return controller;
          })
        ],
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
                      hintText: "Search driver name",
                      fieldname: "search",
                      fieldType: "novalidation",
                      prefixWidget: const Icon(Icons.search),
                      onchanged: (val) {
                        searchKey = val.toString();
                        setState(() {});
                      },
                    )),
                    IconButton(
                        onPressed: () async {
                          await Get.toNamed(Routes.signup, arguments: {"isSignup": false});
                          await appController.getcarList("drivers_list");
                        },
                        icon: Icon(size: 40, color: _colors.primarycolour, Icons.add_circle_outlined)),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: pref.driversList.length,
                    itemBuilder: (context, index) {
                      dynamic currentData = pref.driversList[index];
                      return currentData['name'].toString().toLowerCase().contains(searchKey.toLowerCase())
                          ? InkWell(
                              onTap: () {
                                if (selectedIndex.contains(index)) {
                                  selectedIndex.remove(index);
                                } else {
                                  selectedIndex.add(index);
                                }
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: Get.width,
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: UIHelper.roundedBorderWithColor(15, 15, 15, 15, _colors.bluecolor1, borderColor: _colors.greycolor),
                                          child: Container(
                                            height: 60,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: currentData['imgurl'] != null ? NetworkImage("${ApiServices().apiurl}/${currentData['imgurl']}") : AssetImage(_images.profile),
                                                )),
                                          ),
                                        ),
                                        UIHelper.horizontalSpaceMedium,
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              UIHelper.titleTxtStyle(currentData['name'], fntWeight: FontWeight.bold, fntsize: 16, fntcolor: _colors.primarycolour),
                                              UIHelper.titleTxtStyle("${currentData['mobile']}", fntsize: 14, fntWeight: FontWeight.bold),
                                              rowdata1("DL No.", "${currentData['dl_no']}"),
                                              rowdata1("Password", "${currentData['password']}"),
                                              rowdata1("Balance", "₹ ${currentData['cart_amt']}", fntSize: 16, fntclr: _colors.redColour),
                                            ],
                                          ),
                                        ),
                                        Icon(Icons.expand_more, size: 20, color: _colors.greycolor1)
                                      ],
                                    ),
                                    if (selectedIndex.contains(index)) ...[
                                      UIHelper.verticalSpaceSmall,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          UIHelper().actionButton("Add Amount", 15, Get.width / 2.5, bgcolour: _colors.redColour, onPressed: () {
                                            showAmountDialog("Add Amount", "${currentData['_id']}");
                                          }),
                                          UIHelper().actionButton("Deduct Amount", 15, Get.width / 2.5, bgcolour: _colors.bluecolor, onPressed: () {
                                            double cartamt = double.parse("${currentData['cart_amt']}");
                                            if (cartamt > 0) {
                                              showAmountDialog("Deduct Amount", "${currentData['_id']}");
                                            } else {
                                              Utils().showAlert("W", "Cart amount is too low");
                                            }
                                          }),
                                        ],
                                      )
                                    ]
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox();
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
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

  Widget rowdata1(String t1, String t2, {double fntSize = 14, Color fntclr = Colors.blue}) {
    return Row(
      children: [
        Expanded(flex: 2, child: UIHelper.titleTxtStyle(t1, fntsize: fntSize, fntWeight: FontWeight.normal)),
        Expanded(flex: 1, child: UIHelper.titleTxtStyle(":", fntsize: fntSize, fntWeight: FontWeight.normal)),
        Expanded(flex: 3, child: UIHelper.titleTxtStyle(t2, fntsize: fntSize, fntcolor: fntclr, fntWeight: FontWeight.bold)),
      ],
    );
  }

  Future showAmountDialog(String title, String id) async {
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
                            Expanded(child: UIHelper.titleTxtStyle(title, fntcolor: _colors.bgClr, fntsize: 18)),
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
                            const CustomInput(hintText: "Amount", fieldname: "amount", fieldType: "number"),
                            if (title == "Add Amount") UIHelper.verticalSpaceSmall,
                            if (title == "Add Amount") const CustomInput(hintText: "Reason", fieldname: "add_reason", fieldType: "text"),
                            UIHelper.verticalSpaceMedium,
                            UIHelper().actionButton("Submit", 16, Get.width / 3, onPressed: () {
                              if (_formkey.currentState!.saveAndValidate()) {
                                Map<String, dynamic> postParams = Map.from(_formkey.currentState!.value);
                                postParams['service_id'] = "cart_amount_update";
                                postParams['driver_id'] = id;
                                postParams['type'] = title;
                                appController.cartAmtUpdateFun(postParams);
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
