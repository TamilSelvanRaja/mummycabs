import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/static_datas.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:provider/provider.dart';

class DriverDetailsScreen extends StatefulWidget {
  const DriverDetailsScreen({super.key});

  @override
  State<DriverDetailsScreen> createState() => _DriverDetailsScreenState();
}

class _DriverDetailsScreenState extends State<DriverDetailsScreen> {
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
        title: UIHelper.titleTxtStyle("Drivers Details", fntcolor: _colors.bgClr, fntsize: 22),
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
                    IconButton(
                        onPressed: () async {
                          await Get.toNamed(Routes.signup, arguments: {"isSignup": false});
                          await appController.getcarList("drivers_list");
                        },
                        icon: Icon(size: 40, color: _colors.primarycolour, Icons.add_circle_outlined)),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: ListView.separated(
                    itemCount: pref.driversList.length,
                    itemBuilder: (context, index) {
                      dynamic currentData = pref.driversList[index];
                      return currentData['name'].toString().toLowerCase().contains(searchKey.toLowerCase())
                          ? Container(
                              padding: const EdgeInsets.all(8),
                              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                              decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, _colors.whiteColour, isShadow: true),
                              child: Row(
                                children: [
                                  currentData['imgurl'] != null
                                      ? CircleAvatar(
                                          radius: 40,
                                          backgroundColor: _colors.primarycolour,
                                          backgroundImage: NetworkImage("${ApiServices().apiurl}/${currentData['imgurl']}"),
                                        )
                                      : Image.asset(_images.profile, height: 80, width: 80),
                                  UIHelper.horizontalSpaceMedium,
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      UIHelper.titleTxtStyle(currentData['name'], fntWeight: FontWeight.bold, fntsize: 20, fntcolor: _colors.primarycolour),
                                      UIHelper.titleTxtStyle("Mobile No: ${currentData['mobile']}", fntWeight: FontWeight.bold, fntsize: 14),
                                      UIHelper.titleTxtStyle("Licence No: ${currentData['dl_no']}", fntWeight: FontWeight.bold, fntsize: 14),
                                      UIHelper.titleTxtStyle("Aadhar No: ${currentData['aadhar_no']}", fntWeight: FontWeight.bold, fntsize: 14),
                                    ],
                                  )
                                ],
                              ),
                            )
                          : const SizedBox();
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox();
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
