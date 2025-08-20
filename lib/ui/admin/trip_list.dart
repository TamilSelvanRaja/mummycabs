import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';

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
      body: Container(
        padding: const EdgeInsets.all(16),
        height: Get.height,
        width: Get.width,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: CustomInput(
                      hintText: "Search driver name",
                      fieldname: "search",
                      fieldType: "novalidation",
                      prefixWidget: const Icon(Icons.search),
                      onchanged: (val) {
                        //  searchKey = val.toString();
                        setState(() {});
                      },
                    )),
                UIHelper.horizontalSpaceSmall,
                Expanded(
                    flex: 2,
                    child: CustomDatePicker(
                        initValue: "",
                        hintText: "Trip Date",
                        fieldname: "trip_date",
                        onSelected: (val) {
                          // tripDate = val;
                          setState(() {});
                        })),
              ],
            ),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: pref.starttripList.length,
                    itemBuilder: (context, index) {
                      dynamic currentData = pref.starttripList[index];
                      return cardData(index, currentData);
                    }))
          ],
        ),
      ),
    );
  }

  Widget cardData(int index, dynamic currentData) {
    List amountList = currentData['amount_details'];
    dynamic user = Utils().getDriverdetails("${currentData['driver_id']}");

    DateTime inputDate = DateTime.parse(currentData['trip_date'].toString());
    DateFormat format = DateFormat('dd-MM-yyyy');
    String formattedDate = format.format(inputDate);

    return GestureDetector(
      onTap: () {
        if (selectedIndex.contains(index)) {
          selectedIndex.remove(index);
        } else {
          selectedIndex.add(index);
        }
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    UIHelper.titleTxtStyle("Date : $formattedDate", fntcolor: _colors.textColour, fntsize: 12, fntWeight: FontWeight.bold),
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
              rowdata("Total", "${currentData['over_all_cash']}", "${currentData['over_all_operator']}", true, "₹"),
              const Divider(),
              UIHelper.verticalSpaceSmall,
              rowdata1("Driver Salary", "${currentData['driversalary']}", "₹"),
              UIHelper.verticalSpaceSmall,
              rowdata1("Fuel Amount", "${currentData['fuel_amt']}", "₹"),
              UIHelper.verticalSpaceSmall,
              rowdata1("Balance Amount", "${currentData['needtopay']}", "₹"),
              UIHelper.verticalSpaceSmall,
            ]
          ],
        ),
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
