import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:provider/provider.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({super.key});

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
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
        title: UIHelper.titleTxtStyle("Drivers List", fntcolor: _colors.bgClr, fntsize: 22),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) {
            final controller = AppController();
            Future.delayed(const Duration(milliseconds: 600), () {
              controller.getcarList("drivers_list");
            });
            return controller;
          })
        ],
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
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: pref.driversList.length,
                    itemBuilder: (context, index) {
                      dynamic currentData = pref.driversList[index];

                      return currentData['name'].toString().toLowerCase().contains(searchKey.toLowerCase())
                          ? Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await Get.toNamed(Routes.driverdetails, arguments: {"initdata": currentData});
                                    setState(() {});
                                  },
                                  child: SizedBox(
                                    width: Get.width,
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(3),
                                              decoration: UIHelper.circleWithColorWithShadow(1, _colors.bluecolor1, _colors.bluecolor1),
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: currentData['imgurl'] != null ? NetworkImage("${ApiServices().apiurl}/${currentData['imgurl']}") : AssetImage(_images.profile),
                                                    )),
                                              ),
                                            ),
                                            UIHelper.horizontalSpaceMedium,
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  UIHelper.titleTxtStyle(currentData['name'], fntWeight: FontWeight.bold, fntsize: 14, fntcolor: _colors.primarycolour),
                                                  rowdata1("Mobile", "${currentData['mobile']}", fntSize: 14, fntclr: _colors.greenColour),
                                                  rowdata1("Password", "${currentData['password']}", fntSize: 14, fntclr: _colors.redColour),
                                                ],
                                              ),
                                            ),
                                            Icon(Icons.double_arrow_outlined, size: 20, color: _colors.greycolor)
                                          ],
                                        ),
                                        const Divider()
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox();
                    },
                  ),
                ),
              ),
              if (searchKey.isEmpty) ...[
                UIHelper.verticalSpaceSmall,
                Container(
                  padding: const EdgeInsets.all(12),
                  width: Get.width / 2,
                  alignment: Alignment.center,
                  decoration: UIHelper.gradientContainer(15, 15, 15, 15, [_colors.orangeColour, _colors.yellowColour]),
                  child: UIHelper.titleTxtStyle("₹ ${appController.totalcartamount}", fntcolor: _colors.textColour, fntsize: 16, fntWeight: FontWeight.bold),
                )
              ],
              UIHelper.verticalSpaceSmall,
            ],
          );
        }),
      ),
    );
  }

  Widget rowdata1(String t1, String t2, {double fntSize = 14, Color fntclr = Colors.blue}) {
    return Row(
      children: [
        Expanded(flex: 2, child: UIHelper.titleTxtStyle(t1, fntsize: fntSize, fntWeight: FontWeight.normal)),
        Expanded(flex: 1, child: UIHelper.titleTxtStyle(":", fntsize: fntSize, fntWeight: FontWeight.normal)),
        Expanded(flex: 3, child: UIHelper.titleTxtStyle(t2, fntsize: fntSize, fntcolor: fntclr, fntWeight: FontWeight.bold)),
      ],
    );
  }
}
