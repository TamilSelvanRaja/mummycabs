import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:provider/provider.dart';

class DriverTransactionScreen extends StatefulWidget {
  const DriverTransactionScreen({super.key});

  @override
  State<DriverTransactionScreen> createState() => _DriverTransactionScreenState();
}

class _DriverTransactionScreenState extends State<DriverTransactionScreen> {
  final AppColors _colors = AppColors();
  final PreferenceService pref = Get.find<PreferenceService>();
  late AppController appController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      appBar: AppBar(
        backgroundColor: _colors.primarycolour,
        centerTitle: true,
        iconTheme: IconThemeData(color: _colors.bgClr),
        title: UIHelper.titleTxtStyle("Transaction History", fntcolor: _colors.bgClr, fntsize: 22),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            final controller = AppController();
            Future.delayed(const Duration(milliseconds: 600), () {
              controller.gettransactionList("${pref.userdata['_id']}");
            });
            return controller;
          })
        ],
        child: Consumer<AppController>(builder: (context, ref, child) {
          appController = ref;
          return transactionHistory();
        }),
      ),
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
                  decoration: UIHelper.roundedBorderWithColor(15, 15, 15, 15, isAlignright ? _colors.greenColour.withOpacity(0.3) : _colors.redColour.withOpacity(0.3)),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: UIHelper.titleTxtStyle(formatted, fntsize: 8),
                      ),
                      UIHelper.titleTxtStyle("₹ ${currentData['trip_amount']}", fntsize: 14, fntWeight: FontWeight.bold),
                      if (currentData['add_deduct_type'] == "Deduct Amount") ...[
                        rowdata0("Payment Type", " ${currentData['payment_type']}", fntSize: 12, fntclr: _colors.bluecolor),
                      ],
                      if (currentData['add_deduct_type'] == "Add Amount") ...[
                        rowdata0("Reason", " ${currentData['add_reason']}", fntSize: 12, fntclr: _colors.redColour),
                      ],
                      if (currentData['add_deduct_type'] == null) ...[UIHelper.titleTxtStyle("This is a Trip balance amount", fntsize: 10, fntcolor: _colors.redColour)],
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
