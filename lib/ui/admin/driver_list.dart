import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/go_router_services.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';
import 'package:provider/provider.dart';

class DriverListScreen extends StatefulWidget {
  const DriverListScreen({super.key});

  @override
  State<DriverListScreen> createState() => _DriverListScreenState();
}

class _DriverListScreenState extends State<DriverListScreen> {
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();

  late AppController appController;
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  String searchKey = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, Colors.transparent, borderColor: _colors.primarycolour),
          width: Utils().getWidgetWidth(context) / 2,
          child: MultiProvider(
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
              appController.initialize();
              return Column(
                children: [
                  Container(
                    width: Utils().getWidgetWidth(context),
                    height: 100,
                    alignment: Alignment.center,
                    decoration: UIHelper.roundedBorderWithColor(20, 20, 0, 0, _colors.primarycolour),
                    child: UIHelper.titleTxtStyle("Drivers Details", fntcolor: _colors.whiteColour, fntsize: 30, fntWeight: FontWeight.bold),
                  ),
                  Container(
                    height: 50,
                    width: Utils().getWidgetWidth(context),
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
                              await context.push(Routes.signup, extra: {"isSignup": false});
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
                        itemCount: appController.admin_deriverList.length,
                        itemBuilder: (context, index) {
                          dynamic currentData = appController.admin_deriverList[index];

                          return currentData['name'].toString().toLowerCase().contains(searchKey.toLowerCase())
                              ? Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await context.push(Routes.driverdetails, extra: {"initdata": currentData});
                                        setState(() {});
                                      },
                                      child: SizedBox(
                                        width: Utils().getWidgetWidth(context),
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
                                                      rowdata1("Password", "${currentData['password']}", fntSize: 14, fntclr: _colors.bluecolor),
                                                      UIHelper.verticalSpaceSmall,
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                showCarAddDialog(currentData);
                                                              },
                                                              icon: Icon(Icons.edit, size: 20, color: _colors.primarycolour)),
                                                          IconButton(
                                                              onPressed: () {
                                                                Utils().showAlert("De", "Do you want to delete driver \n\"${currentData['name']}\" ?", onComplete: () {
                                                                  Map<String, dynamic> postParams = {'service_id': "user_deactivate", "_id": currentData['_id'], "active_flag": 0};
                                                                  appController.deactivatedrivers(postParams);
                                                                });
                                                              },
                                                              icon: Icon(Icons.delete, size: 20, color: _colors.redColour)),
                                                        ],
                                                      )
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
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      width: Utils().getWidgetWidth(context) / 2,
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
        ),
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

  Future showCarAddDialog(dynamic currentdata) async {
    await Get.dialog<void>(barrierDismissible: false, StatefulBuilder(builder: (context, setState) {
      return MediaQuery.removeViewInsets(
          removeBottom: true,
          context: context,
          child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              backgroundColor: _colors.bgClr,
              insetPadding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                        height: 50,
                        decoration: UIHelper.roundedBorderWithColor(16, 16, 0, 0, _colors.primarycolour),
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Expanded(child: UIHelper.titleTxtStyle("Edit Driver", fntcolor: _colors.bgClr, fntsize: 18)),
                            InkWell(
                              onTap: (() {
                                 context.pop();;
                              }),
                              child: Icon(Icons.close_rounded, size: 30, color: _colors.bgClr),
                            ),
                          ],
                        )),
                    UIHelper.verticalSpaceMedium,
                    FormBuilder(
                      key: _formkey,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(children: [
                            CustomInput(hintText: "Name", initValue: currentdata['name'], fieldname: "name", fieldType: "name"),
                            UIHelper.verticalSpaceSmall,
                            CustomInput(hintText: "Mobile", initValue: currentdata['mobile'], fieldname: "mobile", fieldType: "mobile"),
                            UIHelper.verticalSpaceMedium,
                            CustomInput(hintText: "Password", initValue: currentdata['password'], fieldname: "password", fieldType: "text"),
                            UIHelper.verticalSpaceMedium,
                            UIHelper().actionButton("Submit", 16, Utils().getWidgetWidth(context) / 3, onPressed: () async {
                              if (_formkey.currentState!.saveAndValidate()) {
                                Map<String, dynamic> postParams = Map.from(_formkey.currentState!.value);
                                postParams['service_id'] = "driver_update";
                                postParams['_id'] = currentdata['_id'];
                                appController.driverupdate(context,postParams);
                              }
                            }),
                          ])),
                    ),
                    UIHelper.verticalSpaceMedium,
                  ],
                ),
              )));
    }));
  }
}
