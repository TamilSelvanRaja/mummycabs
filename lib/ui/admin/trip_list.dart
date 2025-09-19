import 'package:flutter/material.dart';
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

class TripListPage extends StatefulWidget {
  const TripListPage({super.key});

  @override
  State<TripListPage> createState() => _TripListPageState();
}

class _TripListPageState extends State<TripListPage> {
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();
  final PreferenceService pref = Get.find<PreferenceService>();
  List selectedIndex = [];
  late AppController appController;
  String selectedDate = "";
  @override
  void initState() {
    super.initState();
    DateTime inputDate = DateTime.now();
    DateFormat format = DateFormat('dd-MM-yyyy');
    selectedDate = format.format(inputDate);
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
        title: UIHelper.titleTxtStyle("Trip List", fntcolor: _colors.bgClr, fntsize: 22),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            final controller = AppController();
            Future.delayed(const Duration(seconds: 1), () {
              controller.gettripList(selectedDate);
            });
            return controller;
          })
        ],
        child: Consumer<AppController>(builder: (context, ref, child) {
          appController = ref;
          return Container(
            padding: const EdgeInsets.all(16),
            height: Get.height,
            width: Get.width,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: CustomDatePicker(
                            initValue: selectedDate,
                            hintText: "Trip Date",
                            fieldname: "trip_date",
                            onSelected: (val) {
                              appController.gettripList(val);
                              selectedDate = val;
                              setState(() {});
                            })),
                    UIHelper.horizontalSpaceSmall,
                    Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: UIHelper.gradientContainer(15, 15, 15, 15, [_colors.orangeColour, _colors.yellowColour]),
                          child: UIHelper.titleTxtStyle("₹ ${double.parse(appController.tripdayamount).toStringAsFixed(2)}", fntcolor: _colors.textColour, fntsize: 16, fntWeight: FontWeight.bold),
                        )),
                  ],
                ),
                UIHelper.verticalSpaceSmall,
                Expanded(
                    child: appController.tripsList.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: appController.tripsList.length,
                            itemBuilder: (context, index) {
                              dynamic currentData = appController.tripsList[index];
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
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, _colors.whiteColour, isShadow: true, shadowColor: _colors.primarycolour),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
          Positioned(
              right: 5,
              top: 5,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        Utils().showAlert("De", "Do you want to delete?", onComplete: () async {
                          Map<String, dynamic> postParams = {
                            'service_id': "delete_trip",
                            'trip_id': currentData['_id'],
                          };
                          await appController.deleteTrip(postParams);
                          appController.gettripList(selectedDate);
                        });
                      },
                      icon: Icon(Icons.delete, size: 25, color: _colors.redColour)),
                ],
              ))
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
}
