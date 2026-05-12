import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/utils.dart';
import 'package:mummy_cabs/ui/widgets/custom_header.dart';
import 'package:provider/provider.dart';

class CustomerDetails extends StatefulWidget {
  const CustomerDetails({super.key});

  @override
  State<CustomerDetails> createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
  final AppColors _colors = AppColors();
  late AppController appController;

  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  String searchKey = "";

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
            providers: [ChangeNotifierProvider(create: (_) => AppController())],
            child: Consumer<AppController>(builder: (context, ref, child) {
              appController = ref;
              appController.initialize();
              return Column(
                children: [
                  CustomHeader(title: "Customer's Detail"),
                  Container(
                    height: 50,
                    width: Utils().getWidgetWidth(context),
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
                        itemCount: appController.admin_customerList.length,
                        itemBuilder: (context, index) {
                          dynamic currentData = appController.admin_customerList[index];
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
        ),
      ),
    );
  }

  Future showAddCustomer() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
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
                                context.pop();
                                ;
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
                            UIHelper().actionButton("Submit", 16, Utils().getWidgetWidth(context) / 3, onPressed: () {
                              if (_formkey.currentState!.saveAndValidate()) {
                                Map<String, dynamic> postParams = Map.from(_formkey.currentState!.value);
                                postParams['service_id'] = "new_customer";
                                appController.newcustomeradd(context, postParams);
                              }
                            }),
                          ])),
                    ),
                    UIHelper.verticalSpaceMedium,
                  ],
                ),
              ));
        });
  }
}
