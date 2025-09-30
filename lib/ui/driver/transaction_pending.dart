import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:provider/provider.dart';

class PendingTransactionScreen extends StatefulWidget {
  const PendingTransactionScreen({super.key});

  @override
  State<PendingTransactionScreen> createState() => _PendingTransactionScreenState();
}

class _PendingTransactionScreenState extends State<PendingTransactionScreen> {
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
        title: UIHelper.titleTxtStyle("Old Transaction", fntcolor: _colors.bgClr, fntsize: 22),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            final controller = AppController();
            Future.delayed(const Duration(milliseconds: 600), () {
              controller.getoldtransactionList("${pref.userdata['_id']}");
            });
            return controller;
          })
        ],
        child: Consumer<AppController>(builder: (context, ref, child) {
          appController = ref;
          return Column(
            children: [
              UIHelper.verticalSpaceSmall,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  UIHelper.titleTxtStyle("Pending Amount :", fntcolor: _colors.redColour, fntsize: 12),
                  UIHelper.horizontalSpaceMedium,
                  Container(
                    height: 40,
                    width: 100,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(5),
                    decoration: UIHelper.gradientContainer(15, 15, 15, 15, [_colors.orangeColour, _colors.yellowColour]),
                    child: UIHelper.titleTxtStyle("₹ ${double.parse(appController.pendingHistoryAmount).toStringAsFixed(2)}", fntcolor: _colors.textColour, fntsize: 12, fntWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(color: _colors.primarycolour),
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
              const Divider(),
              Expanded(child: oldtransactionHistory())
            ],
          );
        }),
      ),
    );
  }

  Widget oldtransactionHistory() {
    return ListView.separated(
      itemCount: appController.oldtransactionList.length,
      itemBuilder: (context, index) {
        dynamic currentData = appController.oldtransactionList[index];
        DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse("${currentData['created_at']}");
        String formatted1 = DateFormat("dd/MM/yyyy").format(dateTime);
        String formatted2 = DateFormat("hh:mm a").format(dateTime);

        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(flex: 2, child: UIHelper.titleTxtStyle("$formatted1\n$formatted2", fntsize: 10)),
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
            ));
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
