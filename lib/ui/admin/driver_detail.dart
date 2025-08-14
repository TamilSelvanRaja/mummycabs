import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/static_datas.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';

class DriverDetailsScreen extends StatefulWidget {
  const DriverDetailsScreen({super.key});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      appBar: AppBar(
        backgroundColor: _colors.primarycolour,
        centerTitle: true,
        iconTheme: IconThemeData(color: _colors.bgClr),
        title: UIHelper.titleTxtStyle("Drivers Details", fntcolor: _colors.bgClr, fntsize: 22),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            width: Get.width,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 5),
            child: const CustomInput(hintText: "Search driver name", fieldname: "search", fieldType: "novalidation", prefixWidget: Icon(Icons.search)),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ListView.separated(
                itemCount: dummydriverdetails.length,
                itemBuilder: (context, index) {
                  dynamic currentData = dummydriverdetails[index];
                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, _colors.whiteColour, isShadow: true),
                    child: Row(
                      children: [
                        Image.asset(_images.profile, height: 80, width: 80),
                        UIHelper.horizontalSpaceMedium,
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UIHelper.titleTxtStyle(currentData['name'], fntWeight: FontWeight.bold, fntsize: 20, fntcolor: _colors.primarycolour),
                            UIHelper.titleTxtStyle("Mobile No: ${currentData['mobile']}", fntWeight: FontWeight.bold, fntsize: 14),
                            UIHelper.titleTxtStyle("Licence No: ${currentData['mobile']}", fntWeight: FontWeight.bold, fntsize: 14),
                          ],
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
