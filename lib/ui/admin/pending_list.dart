import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';
import 'package:provider/provider.dart';

class PendingListPage extends StatefulWidget {
  const PendingListPage({super.key});

  @override
  State<PendingListPage> createState() => _PendingListPageState();
}

class _PendingListPageState extends State<PendingListPage> {
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();
  final PreferenceService pref = Get.find<PreferenceService>();
  List selectedIndex = [];
  late AppController appController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      appBar: AppBar(
        backgroundColor: _colors.primarycolour,
        centerTitle: true,
        iconTheme: IconThemeData(color: _colors.bgClr),
        title: UIHelper.titleTxtStyle("Pending Trip List", fntcolor: _colors.bgClr, fntsize: 22),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            final controller = AppController();

            return controller;
          })
        ],
        child: Consumer<AppController>(builder: (context, ref, child) {
          appController = ref;
          return Container(
            padding: const EdgeInsets.all(10),
            height: Get.height,
            width: Get.width,
            child: Column(
              children: [
                Expanded(
                    child: pref.pendingTripList.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: pref.pendingTripList.length,
                            itemBuilder: (context, index) {
                              dynamic currentData = pref.pendingTripList[index];
                              return cardData(index, currentData);
                            })
                        : Center(child: UIHelper.titleTxtStyle("Data not found")))
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget cardData(int index, dynamic currentData) {
    List amountList = [
      {"type": "OLA", "cash": "${currentData['ola_cash']}", "operator": "${currentData['ola_operator']}"},
      {"type": "UBER", "cash": "${currentData['uber_cash']}", "operator": "${currentData['uber_operator']}"},
      {"type": "RAPIDO", "cash": "${currentData['rapido_cash']}", "operator": "${currentData['rapido_operator']}"},
      {"type": "Others", "cash": "${currentData['other_cash']}", "operator": "${currentData['other_operator']}"},
    ];
    dynamic user = Utils().getDriverdetails("${currentData['driver_id']}");

    return GestureDetector(
      onTap: () {
        if (selectedIndex.contains(index)) {
          selectedIndex.remove(index);
        } else {
          selectedIndex.add(index);
        }
        setState(() {});
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, _colors.whiteColour, isShadow: true, shadowColor: _colors.primarycolour),
            child: Column(
              children: [
                Row(
                  children: [
                    user['imgurl'] != null
                        ? CircleAvatar(
                            radius: 25,
                            backgroundColor: _colors.primarycolour,
                            backgroundImage: NetworkImage("${ApiServices().apiurl}/${user['imgurl']}"),
                          )
                        : Image.asset(_images.profile, height: 50, width: 50),
                    UIHelper.horizontalSpaceSmall,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UIHelper.titleTxtStyle(user['name'], fntcolor: _colors.primarycolour, fntsize: 14, fntWeight: FontWeight.bold),
                        UIHelper.titleTxtStyle(currentData['vehicle_no'], fntcolor: _colors.textColour, fntsize: 12, fntWeight: FontWeight.bold),
                        UIHelper.titleTxtStyle("Date : ${currentData['trip_date']}", fntcolor: _colors.textColour, fntsize: 12, fntWeight: FontWeight.bold),
                        UIHelper.titleTxtStyle("Amount : ₹ ${currentData['balance_amount']}", fntcolor: _colors.redColour, fntsize: 14, fntWeight: FontWeight.bold),
                      ],
                    )
                  ],
                ),
                if (selectedIndex.contains(index)) ...[
                  Divider(color: _colors.primarycolour),
                  rowdata("Company", "Cash", "Operatot", true, ""),
                  UIHelper.verticalSpaceSmall,
                  Column(
                    children: List.generate(amountList.length, (i) {
                      Map<String, dynamic> data = amountList[i];
                      return rowdata("${data['type']}", "${data['cash']}", "${data['operator']}", false, "₹");
                    }),
                  ),
                  const Divider(),
                  rowdata("Total", "${currentData['total_cash_amt']}", "${currentData['total_operator_amt']}", true, "₹"),
                  const Divider(),
                  UIHelper.verticalSpaceSmall,
                  rowdata1("Driver Salary (${currentData['salary_percentage']}%)", "${currentData['driver_salary']}", "₹"),
                  UIHelper.verticalSpaceSmall,
                  rowdata1("Fuel Amount", "${currentData['fuel_amt']}", "₹"),
                  UIHelper.verticalSpaceSmall,
                  rowdata1("Other Expences", "${currentData['other_expences']}", "₹"),
                  UIHelper.verticalSpaceSmall,
                  rowdata1("Balance Amount", "${currentData['balance_amount']}", "₹"),
                  UIHelper.verticalSpaceMedium,
                  Center(
                    child: UIHelper().actionButton("Submit", 18, Get.width / 2, bgcolour: _colors.primarycolour, onPressed: () {
                      Map<String, dynamic> reqData = Map.from(currentData);
                      reqData['service_id'] = "new_trip";
                      AppController().newTripStart(reqData);
                    }),
                  ),
                  UIHelper.verticalSpaceSmall,
                ]
              ],
            ),
          ),
          Positioned(
              right: 5,
              top: 5,
              child: IconButton(
                  onPressed: () async {
                    await Get.toNamed(Routes.starttrip, arguments: {"isedit": true, "initdata": currentData});
                    setState(() {});
                  },
                  icon: Icon(Icons.edit, size: 30, color: _colors.bluecolor)))
        ],
      ),
    );
  }

  Widget rowdata(String t1, String t2, String t3, bool isheading, String prefixTxt) {
    return Row(
      children: [
        Expanded(flex: 2, child: UIHelper.titleTxtStyle(t1, fntsize: 14, fntWeight: isheading ? FontWeight.bold : FontWeight.normal)),
        Expanded(flex: 2, child: UIHelper.titleTxtStyle("$prefixTxt $t2", fntsize: 14, fntWeight: isheading ? FontWeight.bold : FontWeight.normal)),
        Expanded(flex: 2, child: UIHelper.titleTxtStyle("$prefixTxt $t3", fntsize: 14, fntWeight: isheading ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget rowdata1(String t1, String t2, String prefixTxt) {
    return Row(
      children: [
        Expanded(flex: 3, child: UIHelper.titleTxtStyle(t1, fntsize: 14, fntWeight: FontWeight.normal)),
        Expanded(flex: 1, child: UIHelper.titleTxtStyle(":", fntsize: 14, fntWeight: FontWeight.normal)),
        Expanded(flex: 2, child: UIHelper.titleTxtStyle("$prefixTxt $t2", fntsize: 14, fntWeight: FontWeight.bold)),
      ],
    );
  }
}
