import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';
import 'package:provider/provider.dart';

class CompantTripList extends StatefulWidget {
  const CompantTripList({super.key});

  @override
  State<CompantTripList> createState() => _CompantTripListState();
}

class _CompantTripListState extends State<CompantTripList> {
  final AppColors _colors = AppColors();
  final PreferenceService pref = Get.find<PreferenceService>();

  late AppController appController;

  String fromDate = "", toDate = "", cusId = "";
  @override
  void initState() {
    super.initState();
    fromDate = Get.arguments['from'];
    toDate = Get.arguments['to'];
    cusId = Get.arguments['cusId'];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          final controller = AppController();
          Future.delayed(const Duration(seconds: 1), () {
            controller.getCompanytripList(fromDate, toDate, cusId);
          });
          return controller;
        })
      ],
      child: Consumer<AppController>(builder: (context, ref, child) {
        appController = ref;
        return Scaffold(
          backgroundColor: _colors.bgClr,
          appBar: AppBar(
            backgroundColor: _colors.primarycolour,
            centerTitle: true,
            iconTheme: IconThemeData(color: _colors.bgClr),
            title: UIHelper.titleTxtStyle("Company Trip List", fntcolor: _colors.bgClr, fntsize: 18),
            actions: [
              if (appController.companytripsList.isNotEmpty)
                IconButton(
                    onPressed: () async {
                      await AppController().generateInvoiceReport(fromDate, toDate, cusId);
                    },
                    icon: const Icon(Icons.mail, size: 25))
            ],
          ),
          body: Container(
            padding: const EdgeInsets.all(10),
            height: Get.height,
            width: Get.width,
            child: appController.companytripsList.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: appController.companytripsList.length,
                    itemBuilder: (context, index) {
                      dynamic currentData = appController.companytripsList[index];
                      return cardData(index, currentData);
                    })
                : Center(child: UIHelper.titleTxtStyle("Data not found")),
          ),
        );
      }),
    );
  }

  Widget cardData(int index, dynamic currentData) {
    dynamic user = Utils().getDriverdetails("${currentData['driver_id']}");
    dynamic customer = Utils().getCustomerrdetails("${currentData['customer_id']}");
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, _colors.whiteColour, isShadow: true, shadowColor: _colors.primarycolour),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UIHelper.titleTxtStyle(customer['name'], fntcolor: _colors.primarycolour, fntsize: 14, fntWeight: FontWeight.bold),
              UIHelper.titleTxtStyle("${currentData['pickup_time']} (to) ${currentData['drop_time']}", fntcolor: _colors.bluecolor, fntsize: 10, fntWeight: FontWeight.bold),
            ],
          ),
          Divider(color: _colors.greycolor1),
          Row(
            children: [
              UIHelper.titleTxtStyle(user['name'].toString().toUpperCase(), fntcolor: _colors.orangeColour, fntsize: 14, fntWeight: FontWeight.bold),
              UIHelper.titleTxtStyle(" - (${currentData['vehicle_no']})", fntcolor: _colors.textColour, fntsize: 12),
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 20, color: _colors.bluecolor),
              UIHelper.horizontalSpaceTiny,
              UIHelper.titleTxtStyle("${currentData['pickup_place']} - ${currentData['drop_place']}", fntcolor: _colors.textColour, fntsize: 12),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  rowwidget1("Package Hour", "${currentData['total_hr']}"),
                  rowwidget1("Extra Km", "${currentData['extra_km']}"),
                  rowwidget("Toll Amount", "${currentData['toll_amt']}"),
                  rowwidget("Others", "${currentData['other_amount']}"),
                  rowwidget1("Type", currentData['type_id'] == 0 ? "Local" : "Outstation", txtClr: _colors.bluecolor),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  rowwidget1("Total Km", "${currentData['km']}"),
                  rowwidget1("Ex.Km Amt", "${currentData['extra_km_amount']}"),
                  rowwidget("Driver Salary", "${currentData['driver_salary']}"),
                  rowwidget("Parking", "${currentData['parking']}"),
                  rowwidget("Advance", "${currentData['advance_amt']}", txtClr: _colors.greenColour),
                ],
              )
            ],
          ),
          UIHelper.verticalSpaceSmall,
          currentData['description'].toString().isNotEmpty
              ? UIHelper.titleTxtStyle("${currentData['description']}", fntcolor: _colors.orangeColour, fntsize: 15, textOverflow: TextOverflow.visible)
              : const SizedBox(),
          Divider(color: _colors.primarycolour),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              rowwidget("Balance", "${currentData['balance_amount']}", txtClr: _colors.redColour),
              GestureDetector(
                onTap: () async {
                  await Get.toNamed(Routes.companyaddEditTrip, arguments: {"isedit": true, "initdata": currentData});
                  appController.getCompanytripList(fromDate, toDate, cusId);
                },
                child: Container(
                  decoration: UIHelper.roundedBorderWithColor(15, 15, 15, 15, _colors.bluecolor),
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                  child: UIHelper.titleTxtStyle("Edit", fntcolor: _colors.whiteColour, fntWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget rowwidget(title, value, {Color txtClr = Colors.black}) {
    return Row(
      children: [
        UIHelper.titleTxtStyle("$title", fntcolor: _colors.greycolor, fntsize: 13),
        UIHelper.titleTxtStyle(" : ₹ $value", fntcolor: txtClr, fntsize: 13, fntWeight: FontWeight.bold),
      ],
    );
  }

  Widget rowwidget1(title, value, {Color txtClr = Colors.black}) {
    return Row(
      children: [
        UIHelper.titleTxtStyle("$title", fntcolor: _colors.greycolor, fntsize: 13),
        UIHelper.titleTxtStyle(" : $value", fntcolor: txtClr, fntsize: 13, fntWeight: FontWeight.bold),
      ],
    );
  }
}
