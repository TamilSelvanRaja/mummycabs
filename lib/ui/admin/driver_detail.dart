import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
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
  int selectedHistory = 0;
  dynamic initialData = {};
  @override
  void initState() {
    super.initState();
    initialData = Get.arguments['initdata'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      body: SafeArea(
        top: true,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) {
              final controller = AppController();
              Future.delayed(const Duration(milliseconds: 600), () {
                controller.gettransactionList(initialData['_id'].toString());
                controller.getoldtransactionList(initialData['_id'].toString());
              });
              return controller;
            })
          ],
          child: Consumer<AppController>(builder: (context, ref, child) {
            appController = ref;
            return Column(
              children: [
                Row(
                    children: List.generate(2, (index) {
                  return GestureDetector(
                    onTap: () {
                      selectedHistory = index;
                      setState(() {});
                    },
                    child: Container(
                      width: Get.width / 2,
                      alignment: Alignment.center,
                      decoration: UIHelper.roundedBorderWithColor(0, 0, 0, 0, index == selectedHistory ? _colors.primarycolour : _colors.greycolor1),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: UIHelper.titleTxtStyle(index == 0 ? "Trip History" : "Pending History",
                          fntcolor: index == selectedHistory ? _colors.whiteColour : _colors.blackColour, fntsize: 14, fntWeight: FontWeight.bold),
                    ),
                  );
                })),
                UIHelper.verticalSpaceSmall,
                if (selectedHistory == 1) ...[
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: UIHelper.titleTxtStyle("Date", fntsize: 12, fntWeight: FontWeight.bold, fntcolor: _colors.primarycolour)),
                          Expanded(flex: 3, child: UIHelper.titleTxtStyle("Amount", fntsize: 12, fntWeight: FontWeight.bold, fntcolor: _colors.primarycolour)),
                          Expanded(flex: 2, child: UIHelper.titleTxtStyle("Cr/Dr", fntsize: 12, fntWeight: FontWeight.bold, fntcolor: _colors.primarycolour)),
                          Expanded(flex: 2, child: UIHelper.titleTxtStyle("Pending", fntsize: 12, fntWeight: FontWeight.bold, fntcolor: _colors.primarycolour)),
                        ],
                      )),
                  const Divider()
                ],
                Expanded(child: selectedHistory == 0 ? transactionHistory() : oldtransactionHistory()),
                Divider(color: _colors.primarycolour),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      UIHelper.titleTxtStyle(
                          selectedHistory == 0 ? "₹ ${double.parse("${initialData['cart_amt']}").toStringAsFixed(2)}" : "₹ ${double.parse(appController.pendingHistoryAmount).toStringAsFixed(2)}",
                          fntWeight: FontWeight.bold,
                          fntcolor: double.parse("${initialData['cart_amt']}") > 0 ? _colors.redColour : _colors.greenColour),
                      const Spacer(),
                      UIHelper().actionButton("Add", 11, Get.width / 4, bgcolour: _colors.redColour, onPressed: () {
                        showAmountDialog("Add Amount", "${initialData['_id']}");
                      }),
                      UIHelper.horizontalSpaceSmall,
                      UIHelper().actionButton("Deduct", 11, Get.width / 4, bgcolour: _colors.greenColour, onPressed: () {
                        showAmountDialog("Deduct Amount", "${initialData['_id']}");
                      }),
                    ],
                  ),
                ),
                UIHelper.verticalSpaceSmall
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget rowdata1(String t1, String t2, {double fntSize = 12, Color fntclr = Colors.blue}) {
    return Row(
      children: [
        Expanded(flex: 2, child: UIHelper.titleTxtStyle(t1, fntsize: fntSize, fntWeight: FontWeight.normal)),
        Expanded(flex: 1, child: UIHelper.titleTxtStyle(":", fntsize: fntSize, fntWeight: FontWeight.normal)),
        Expanded(flex: 3, child: UIHelper.titleTxtStyle(t2, fntsize: fntSize, fntcolor: fntclr, fntWeight: FontWeight.bold)),
      ],
    );
  }

  Widget rowdata0(String t1, String t2, {double fntSize = 12, Color fntclr = Colors.blue}) {
    return Row(
      children: [
        UIHelper.titleTxtStyle(t1, fntsize: fntSize, fntWeight: FontWeight.normal),
        UIHelper.horizontalSpaceSmall,
        UIHelper.titleTxtStyle(":", fntsize: fntSize, fntWeight: FontWeight.normal),
        UIHelper.horizontalSpaceTiny,
        UIHelper.titleTxtStyle(t2, fntsize: fntSize, fntcolor: fntclr, fntWeight: FontWeight.bold),
      ],
    );
  }

  Widget transactionHistory() {
    return ListView.builder(
        itemCount: appController.transactionList.length,
        itemBuilder: (context, index) {
          dynamic currentData = appController.transactionList[index];
          bool isAlignright = currentData['add_deduct_type'] == "Deduct Amount";
          DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse("${currentData['created_at']}");
          String formatted = DateFormat("dd/MM/yyyy hh:mm a").format(dateTime);

          return Column(
            children: [
              Align(
                alignment: isAlignright ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: Get.width / 1.5,
                  padding: const EdgeInsets.all(10),
                  decoration: UIHelper.roundedBorderWithColor(15, 15, 15, 15, isAlignright ? _colors.greenColour.withOpacity(0.2) : _colors.redColour.withOpacity(0.2)),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: UIHelper.titleTxtStyle(formatted, fntsize: 12),
                      ),
                      UIHelper.titleTxtStyle("₹ ${currentData['trip_amount']}", fntsize: 14, fntWeight: FontWeight.bold),
                      if (currentData['add_deduct_type'] == "Deduct Amount") ...[
                        rowdata0("Payment Type", " ${currentData['payment_type']}", fntSize: 12, fntclr: _colors.bluecolor),
                      ],
                      if (currentData['add_reason'] != null && currentData['add_reason'] != "") ...[
                        rowdata0("Reason", " ${currentData['add_reason']}", fntSize: 12, fntclr: _colors.redColour),
                      ],
                      if (currentData['add_deduct_type'] == null) ...[UIHelper.titleTxtStyle("This is a Trip balance amount", fntsize: 10, fntcolor: _colors.redColour)],
                      UIHelper.verticalSpaceSmall,
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Utils().showAlert("De", "Do you want to delete?", onComplete: () async {
                              Map<String, dynamic> postParams = {'service_id': "history_delete", 'history_id': currentData['_id'], 'driver_id': currentData['driver_id']};
                              await appController.cartAmtUpdateFun(postParams);
                              Get.back();
                              await appController.gettransactionList(currentData['driver_id']);
                            });
                          },
                          child: Container(
                            decoration: UIHelper.roundedBorderWithColor(10, 10, 10, 10, _colors.redColour),
                            padding: const EdgeInsets.all(5),
                            width: Get.width / 4,
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: _colors.whiteColour, size: 20),
                                UIHelper.horizontalSpaceTiny,
                                UIHelper.titleTxtStyle("Delete", fntsize: 12, fntcolor: _colors.whiteColour, fntWeight: FontWeight.bold)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget oldtransactionHistory() {
    return ListView.separated(
      itemCount: appController.oldtransactionList.length,
      itemBuilder: (context, index) {
        dynamic currentData = appController.oldtransactionList[index];
        DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse("${currentData['created_at']}");
        String formatted1 = DateFormat("dd/MM/yyyy").format(dateTime);
        String formatted2 = DateFormat("hh:mm a").format(dateTime);

        return GestureDetector(
          onDoubleTap: () {
            Utils().showAlert("De", "Do you want to delete?", onComplete: () async {
              Map<String, dynamic> postParams = {'service_id': "delete_pending_history", 'id': currentData['_id'], 'driver_id': currentData['driver_id']};
              await appController.oldPendingAdd(postParams);
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(flex: 2, child: UIHelper.titleTxtStyle("$formatted1\n$formatted2", fntsize: 11)),
                    Expanded(
                      flex: 3,
                      child: UIHelper.titleTxtStyle("₹ ${currentData['amount']}",
                          fntsize: 12, fntWeight: FontWeight.bold, fntcolor: currentData['type'] == "DR" ? _colors.greenColour : _colors.redColour),
                    ),
                    Expanded(flex: 2, child: UIHelper.titleTxtStyle("${currentData['type']}", fntsize: 12)),
                    Expanded(flex: 2, child: UIHelper.titleTxtStyle("₹ ${currentData['avl_bal']}", fntsize: 12, fntWeight: FontWeight.bold)),
                  ],
                ),
                currentData['pay_type'] != "" ? UIHelper.titleTxtStyle("${currentData['pay_type']}", fntsize: 12, fntcolor: _colors.orangeColour) : SizedBox(),
                UIHelper.titleTxtStyle("${currentData['add_reason']}", fntsize: 12, fntcolor: _colors.bluecolor)
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
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
                            UIHelper.verticalSpaceSmall,
                            if (title != "Add Amount") ...[
                              CustomDropDown(initList: pref.paymentTypes, hintText: "Payment Type", fieldname: "payment_type", onSelected: (val) {}),
                              UIHelper.verticalSpaceSmall,
                            ],
                            const CustomInput(hintText: "Reason", fieldname: "add_reason", fieldType: "text"),
                            UIHelper.verticalSpaceMedium,
                            UIHelper().actionButton("Submit", 16, Get.width / 3, onPressed: () async {
                              if (_formkey.currentState!.saveAndValidate()) {
                                Map<String, dynamic> postParams = Map.from(_formkey.currentState!.value);
                                if (selectedHistory == 0) {
                                  postParams['service_id'] = "cart_amount_update";
                                  postParams['driver_id'] = id;
                                  postParams['type'] = title;
                                  await appController.cartAmtUpdateFun(postParams);
                                  Get.back();
                                  await appController.gettransactionList(id);
                                } else {
                                  Get.back();
                                  postParams['service_id'] = "old_pending_add";
                                  postParams['driver_id'] = id;
                                  postParams['type'] = title == "Add Amount" ? "CR" : "DR";
                                  await appController.oldPendingAdd(postParams);
                                }
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
