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
      appBar: AppBar(
        backgroundColor: _colors.primarycolour,
        centerTitle: true,
        iconTheme: IconThemeData(color: _colors.bgClr),
        title: UIHelper.titleTxtStyle("Driver Details", fntcolor: _colors.bgClr, fntsize: 22),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            final controller = AppController();
            Future.delayed(const Duration(milliseconds: 600), () {
              controller.gettransactionList(initialData['_id'].toString());
            });
            return controller;
          })
        ],
        child: Consumer<AppController>(builder: (context, ref, child) {
          appController = ref;
          return Column(
            children: [
              Container(
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
                                  image: initialData['imgurl'] != null ? NetworkImage("${ApiServices().apiurl}/${initialData['imgurl']}") : AssetImage(_images.profile),
                                )),
                          ),
                        ),
                        UIHelper.horizontalSpaceMedium,
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              UIHelper.titleTxtStyle(initialData['name'], fntWeight: FontWeight.bold, fntsize: 16, fntcolor: _colors.primarycolour),
                              UIHelper.titleTxtStyle("${initialData['mobile']}", fntsize: 14, fntWeight: FontWeight.bold),
                              rowdata1("DL No.", "${initialData['dl_no']}"),
                              rowdata1("Password", "${initialData['password']}"),
                              rowdata1(
                                "Balance",
                                "₹ ${double.parse("${initialData['cart_amt']}").toStringAsFixed(2)}",
                                fntSize: 12,
                                fntclr: double.parse("${initialData['cart_amt']}") > 0 ? _colors.redColour : _colors.greenColour,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpaceSmall,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        UIHelper().actionButton("Add Amount", 11, Get.width / 3, bgcolour: _colors.redColour, onPressed: () {
                          showAmountDialog("Add Amount", "${initialData['_id']}");
                        }),
                        UIHelper().actionButton("Deduct Amount", 11, Get.width / 3, bgcolour: _colors.bluecolor, onPressed: () {
                          double cartamt = double.parse("${initialData['cart_amt']}");
                          if (cartamt > 0) {
                            showAmountDialog("Deduct Amount", "${initialData['_id']}");
                          } else {
                            Utils().showAlert("W", "Cart amount is too low");
                          }
                        }),
                      ],
                    )
                  ],
                ),
              ),
              Divider(color: _colors.primarycolour),
              Container(
                width: Get.width,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: UIHelper.titleTxtStyle("Transaction History", fntsize: 14, fntWeight: FontWeight.bold),
              ),
              Expanded(child: transactionHistory())
            ],
          );
        }),
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
                                postParams['service_id'] = "cart_amount_update";
                                postParams['driver_id'] = id;
                                postParams['type'] = title;
                                await appController.cartAmtUpdateFun(postParams);
                                Get.back();
                                await appController.gettransactionList(id);
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
