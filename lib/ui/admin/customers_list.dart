import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';
import 'package:provider/provider.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({super.key});

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final AppColors _colors = AppColors();
  late AppController appController;
  final PreferenceService pref = Get.find<PreferenceService>();
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  String searchKey = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      appBar: AppBar(
        backgroundColor: _colors.primarycolour,
        centerTitle: true,
        iconTheme: IconThemeData(color: _colors.bgClr),
        title: UIHelper.titleTxtStyle("Customer's Detail", fntcolor: _colors.bgClr, fntsize: 22),
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
                      hintText: "Search name",
                      fieldname: "search",
                      fieldType: "novalidation",
                      prefixWidget: const Icon(Icons.search),
                      onchanged: (val) {
                        searchKey = val.toString();
                        setState(() {});
                      },
                    )),
                    IconButton(
                        onPressed: () {
                          showAddCustomer();
                        },
                        icon: Icon(size: 40, color: _colors.primarycolour, Icons.add_circle_outlined)),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: pref.customersList.length,
                    itemBuilder: (context, index) {
                      dynamic currentData = pref.customersList[index];
                      return currentData['name'].toString().toLowerCase().contains(searchKey.toLowerCase()) || currentData['reg_no'].toString().toLowerCase().contains(searchKey.toLowerCase())
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(flex: 1, child: UIHelper.titleTxtStyle("${index + 1}", fntsize: 14)),
                                    Expanded(flex: 3, child: UIHelper.titleTxtStyle(currentData['name'].toString().toUpperCase(), fntsize: 14)),
                                  ],
                                ),
                                const Divider()
                              ],
                            )
                          : const SizedBox();
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

  Future showAddCustomer() async {
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
                            Expanded(child: UIHelper.titleTxtStyle("New Customer", fntcolor: _colors.bgClr, fntsize: 18)),
                            InkWell(
                              onTap: (() {
                                Get.back();
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
                            const CustomInput(hintText: "Customer Name", fieldname: "name", fieldType: "cus_name"),
                            UIHelper.verticalSpaceMedium,
                            UIHelper().actionButton("Submit", 16, Get.width / 3, onPressed: () {
                              if (_formkey.currentState!.saveAndValidate()) {
                                Map<String, dynamic> postParams = Map.from(_formkey.currentState!.value);
                                postParams['service_id'] = "new_customer";
                                appController.newcustomeradd(postParams);
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
