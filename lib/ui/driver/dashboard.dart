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
                      UIHelper.titleTxtStyle("Pending Amount :", fntcolor: _colors.redColour, fntsize: 12),
                      UIHelper.horizontalSpaceMedium,
                      Container(
                        height: 40,
                        width: 100,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(5),
                        decoration: UIHelper.gradientContainer(15, 15, 15, 15, [_colors.orangeColour, _colors.yellowColour]),
                        child: UIHelper.titleTxtStyle("₹ ${double.parse("${pref.userdata['cart_amt']}").toStringAsFixed(2)}", fntcolor: _colors.textColour, fntsize: 12, fntWeight: FontWeight.bold),
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
            InkWell(onTap: () => _showPopupMenu(), child: Icon(Icons.menu_rounded, size: 30, color: _colors.whiteColour)),
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
    String fudata = currentData['fuel_details'].toString().replaceAll("/", ", ");

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
                  if (currentData['duty_desc'] != null && currentData['duty_desc'] != "") ...[
                    UIHelper.verticalSpaceTiny,
                    Align(alignment: Alignment.centerLeft, child: UIHelper.titleTxtStyle("${currentData['duty_desc']}", fntsize: 14, fntcolor: _colors.bluecolor, txtAlign: TextAlign.left)),
                  ],
                  const Divider(),
                  rowdata("Total", "${currentData['total_cash_amt']}", "${currentData['total_operator_amt']}", true, "₹"),
                  const Divider(),
                  UIHelper.verticalSpaceSmall,
                  rowdata1("Driver Salary (${currentData['salary_percentage']}%)", "${currentData['driver_salary']}", "₹"),
                  UIHelper.verticalSpaceSmall,
                  rowdata1("Fuel Amount", "${currentData['fuel_amt']}", "₹"),
                  if (fudata != "null" && fudata != "") ...[
                    UIHelper.verticalSpaceTiny,
                    UIHelper.titleTxtStyle(fudata, fntcolor: _colors.redColour, fntsize: 12),
                  ],
                  UIHelper.verticalSpaceSmall,
                  rowdata1("KM", "${currentData['total_operator_amt']}/${currentData['kilometer']} = ${currentData['per_km']}", ""),
                  UIHelper.verticalSpaceSmall,
                  rowdata1("Other Expences", "${currentData['other_expences']}", "₹"),
                  UIHelper.verticalSpaceSmall,
                  if (currentData['other_desc'] != "" && currentData['other_desc'] != null) ...[
                    Align(alignment: Alignment.centerLeft, child: UIHelper.titleTxtStyle("${currentData['other_desc']}", fntsize: 14, fntcolor: _colors.bluecolor, txtAlign: TextAlign.left)),
                    UIHelper.verticalSpaceSmall,
                  ],
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
        Expanded(flex: 2, child: UIHelper.titleTxtStyle(t1, fntsize: 14, fntWeight: FontWeight.normal)),
        UIHelper.titleTxtStyle(":", fntsize: 14, fntWeight: FontWeight.normal),
        UIHelper.horizontalSpaceTiny,
        Expanded(flex: 2, child: UIHelper.titleTxtStyle("$prefixTxt $t2", fntsize: 14, fntWeight: FontWeight.bold)),
      ],
    );
  }

  itemWidget(title, int i, IconData icon) {
    return InkWell(
      onTap: () {
        Get.back();
        if (i == 0) {
          Get.toNamed(Routes.driverTransaction);
        } else {
          Utils().showAlert("O", "Do you want to logout?", subTitle: "Logout", onComplete: () {
            pref.cleanAllPreferences();
            Get.offNamedUntil(Routes.initial, (p) => false);
          });
        }
      },
      child: Row(
        children: [
          Icon(
            icon,
            color: _colors.primarycolour,
          ),
          UIHelper.horizontalSpaceTiny,
          UIHelper.titleTxtStyle(title)
        ],
      ),
    );
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width - 40, kToolbarHeight, 10, 0),
      items: [
        PopupMenuItem<String>(
          child: itemWidget("Transaction Status", 0, Icons.receipt_long_sharp),
        ),
        PopupMenuItem<String>(
          child: itemWidget("Logout", 1, Icons.logout_rounded),
        ),
      ],
      elevation: 8.0,
    );
  }
}
