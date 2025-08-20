import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:provider/provider.dart';

class CartMainScreen extends StatefulWidget {
  const CartMainScreen({super.key});

  @override
  State<CartMainScreen> createState() => _CartMainScreenState();
}

class _CartMainScreenState extends State<CartMainScreen> {
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();
  final PreferenceService pref = Get.find<PreferenceService>();
  late AppController appController;
  String searchKey = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      appBar: AppBar(
        backgroundColor: _colors.primarycolour,
        centerTitle: true,
        iconTheme: IconThemeData(color: _colors.bgClr),
        title: UIHelper.titleTxtStyle("Amount Details", fntcolor: _colors.bgClr, fntsize: 22),
      ),
      body: MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => AppController())],
        child: Consumer<AppController>(builder: (context, ref, child) {
          appController = ref;
          return Column(
            children: [
              Container(
                height: 50,
                width: Get.width,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 5),
                child: Row(
                  children: [
                    Expanded(
                        child: CustomInput(
                      hintText: "Search driver name",
                      fieldname: "search",
                      fieldType: "novalidation",
                      prefixWidget: const Icon(Icons.search),
                      onchanged: (val) {
                        searchKey = val.toString();
                        setState(() {});
                      },
                    )),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: pref.driversList.length,
                    itemBuilder: (context, index) {
                      dynamic currentData = pref.driversList[index];
                      return currentData['name'].toString().toLowerCase().contains(searchKey.toLowerCase())
                          ? InkWell(
                              onTap: () {
                                log("Tamil");
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: Get.width,
                                child: Row(
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: _colors.primarycolour,
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: currentData['imgurl'] != null ? NetworkImage("${ApiServices().apiurl}/${currentData['imgurl']}") : AssetImage(_images.profile),
                                          )),
                                    ),
                                    UIHelper.horizontalSpaceMedium,
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          UIHelper.titleTxtStyle(currentData['name'], fntWeight: FontWeight.bold, fntsize: 16, fntcolor: _colors.primarycolour),
                                          UIHelper.titleTxtStyle("₹ 8000", fntWeight: FontWeight.w700, fntsize: 14, fntcolor: _colors.textColour),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.arrow_right_alt_outlined, size: 30, color: _colors.primarycolour)
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox();
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
