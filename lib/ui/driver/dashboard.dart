import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';
import 'package:provider/provider.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  State<DriverDashboard> createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();
  late AppController appController;
  List selectedIndex = [];

  final PreferenceService pref = Get.find<PreferenceService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _colors.bgClr,
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) {
              final controller = AppController();
              Future.delayed(const Duration(seconds: 1), () {
                controller.getdrivertripList("All");
              });
              return controller;
            })
          ],
          child: Consumer<AppController>(builder: (context, ref, child) {
            appController = ref;
            return Column(
              children: [
                customAppBar(),
                UIHelper.verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      UIHelper.titleTxtStyle("Pending Amount :", fntcolor: _colors.redColour, fntsize: 16),
                      UIHelper.horizontalSpaceMedium,
                      Container(
                        height: 50,
                        width: 150,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(16),
                        decoration: UIHelper.gradientContainer(15, 15, 15, 15, [_colors.orangeColour, _colors.yellowColour]),
                        child: UIHelper.titleTxtStyle("₹ ${pref.userdata['cart_amt']}", fntcolor: _colors.textColour, fntsize: 16, fntWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                UIHelper.verticalSpaceSmall,
                Expanded(
                    child: appController.drivertripsList.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: appController.drivertripsList.length,
                            itemBuilder: (context, index) {
                              dynamic currentData = appController.drivertripsList[index];
                              return cardData(index, currentData);
                            })
                        : Center(child: UIHelper.titleTxtStyle("Data not found")))
              ],
            );
          }),
        ),
        floatingActionButton: IconButton(
            onPressed: () async {
              appController.getdrivertripList("All");
              dynamic postParams = {"service_id": "login", "mobile": await pref.getString("mobile"), "password": await pref.getString("password")};
              AppController().cartAmountGet(postParams);
            },
            icon: Icon(size: 40, color: _colors.primarycolour, Icons.replay_circle_filled_outlined)));
  }

  Widget customAppBar() {
    return Container(
        width: Get.width,
        padding: const EdgeInsets.fromLTRB(16, 35, 16, 10),
        color: _colors.primarycolour,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            pref.userdata['imgurl'] != null
                ? CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage("${ApiServices().apiurl}/${pref.userdata['imgurl']}"),
                  )
                : Image.asset(_images.driver, height: 50, width: 50),
            UIHelper.titleTxtStyle("${pref.userdata['name']}", fntcolor: _colors.bgClr, fntsize: 20, fntWeight: FontWeight.bold, txtAlign: TextAlign.center),
            InkWell(
                onTap: () {
                  Utils().showAlert("O", "Do you want to logout?", subTitle: "Logout", onComplete: () {
                    pref.cleanAllPreferences();
                    Get.offNamedUntil(Routes.initial, (p) => false);
                  });
                },
                child: Icon(Icons.logout, size: 26, color: _colors.bgClr)),
          ],
        ));
  }

  Widget cardData(int index, dynamic currentData) {
    List amountList = [
      {"type": "OLA", "cash": "${currentData['ola_cash']}", "operator": "${currentData['ola_operator']}"},
      {"type": "UBER", "cash": "${currentData['uber_cash']}", "operator": "${currentData['uber_operator']}"},
      {"type": "RAPIDO", "cash": "${currentData['rapido_cash']}", "operator": "${currentData['rapido_operator']}"},
      {"type": "Others", "cash": "${currentData['other_cash']}", "operator": "${currentData['other_operator']}"},
    ];

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
            width: Get.width,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, _colors.whiteColour, isShadow: true, shadowColor: _colors.primarycolour),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UIHelper.titleTxtStyle(currentData['vehicle_no'], fntcolor: _colors.textColour, fntsize: 15, fntWeight: FontWeight.bold),
                UIHelper.titleTxtStyle("Date : ${currentData['trip_date']}", fntcolor: _colors.textColour, fntsize: 15, fntWeight: FontWeight.bold),
                UIHelper.titleTxtStyle("Amount : ₹ ${currentData['balance_amount']}", fntcolor: _colors.redColour, fntsize: 16, fntWeight: FontWeight.bold),
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
                  UIHelper.verticalSpaceSmall,
                ]
              ],
            ),
          ),
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
