import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:provider/provider.dart';

class StatementScreen extends StatefulWidget {
  const StatementScreen({super.key});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  final AppColors _colors = AppColors();

  late AppController appController;
  List tempList = [];

  dynamic userdata = {};
  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future initialize() async {
    userdata = await PreferenceService().getjsonData("userdata");
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
        title: UIHelper.titleTxtStyle("Transaction Status", fntcolor: _colors.bgClr, fntsize: 22),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) {
              final controller = AppController();
              Future.delayed(const Duration(milliseconds: 600), () {
                controller.gettransactionList(context, "${userdata['_id']}");
              });
              return controller;
            })
          ],
          child: Consumer<AppController>(builder: (context, ref, child) {
            appController = ref;
            return Column(
              children: [
                UIHelper.verticalSpaceSmall,
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
      ),
    );
  }

  Widget oldtransactionHistory() {
    return ListView.separated(
      itemCount: appController.transactionList.length,
      itemBuilder: (context, index) {
        dynamic currentData = appController.transactionList[index];
        DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse("${currentData['created_at']}");
        String formatted1 = DateFormat("dd/MM/yyyy").format(dateTime);
        String formatted2 = DateFormat("hh:mm a").format(dateTime);
        double amt = double.parse(currentData['trip_amount'].toString());
        double pendingAmt = double.parse(currentData['avl_bal'].toString());

        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            color: currentData['type'] == "DR" ? _colors.greenColour.withOpacity(0.3) : _colors.redColour.withOpacity(0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(flex: 2, child: UIHelper.titleTxtStyle("$formatted1\n$formatted2", fntsize: 10)),
                    Expanded(
                      flex: 3,
                      child: UIHelper.titleTxtStyle("₹ ${amt.toStringAsFixed(2)}", fntsize: 12, fntWeight: FontWeight.bold),
                    ),
                    Expanded(flex: 2, child: UIHelper.titleTxtStyle("${currentData['type']}", fntsize: 12, fntWeight: FontWeight.bold)),
                    Expanded(flex: 2, child: UIHelper.titleTxtStyle("₹ ${pendingAmt.toStringAsFixed(2)}", fntsize: 12, fntWeight: FontWeight.bold)),
                  ],
                ),
                if (currentData['payment_type'] != "" && currentData['payment_type'] != null) UIHelper.titleTxtStyle("${currentData['payment_type']}", fntsize: 12, fntcolor: _colors.redColour),
                if (currentData['add_reason'] != "" && currentData['add_reason'] != null) UIHelper.titleTxtStyle("${currentData['add_reason']}", fntsize: 12, fntcolor: _colors.bluecolor)
              ],
            ));
      },
      separatorBuilder: (context, index) {
        return Container(height: 1, color: _colors.blackColour);
      },
    );
  }
}
