import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';

class FuelMaintanance extends StatefulWidget {
  const FuelMaintanance({super.key, required this.returnData, required this.initialData});
  final dynamic returnData;
  final List initialData;
  @override
  State<FuelMaintanance> createState() => _FuelMaintananceState();
}

class _FuelMaintananceState extends State<FuelMaintanance> {
  final AppColors _colors = AppColors();
  List<Map<String, TextEditingController>> rows = [];
  @override
  void initState() {
    log("initialData ${widget.initialData}");
    super.initState();

    for (var i in widget.initialData) {
      rows.add({
        "type": TextEditingController(text: i['type'].toString()),
        "amount": TextEditingController(text: i['amount'].toString()),
      });
    }
    _addRow(); // start with one row
  }

  void _addRow() {
    setState(() {
      rows.add({
        "type": TextEditingController(),
        "amount": TextEditingController(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return MediaQuery.removeViewInsets(
          removeBottom: true,
          context: context,
          child: AlertDialog(
              contentPadding: EdgeInsets.zero,
              backgroundColor: _colors.bgClr,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              content: SizedBox(
                width: Get.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                      height: 50,
                      decoration: UIHelper.roundedBorderWithColor(16, 16, 0, 0, _colors.primarycolour),
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          Expanded(
                            child: UIHelper.titleTxtStyle("Add Fuel", fntcolor: _colors.bgClr, fntsize: 18),
                          ),
                          InkWell(
                            onTap: () {
                              rows.clear();
                              Get.back();
                            },
                            child: Icon(Icons.close_rounded, size: 30, color: _colors.bgClr),
                          ),
                        ],
                      ),
                    ),

                    UIHelper.verticalSpaceMedium,
                    SizedBox(
                      height: 250, // adjust height as needed
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ListView.builder(
                          itemCount: rows.length,
                          itemBuilder: (context, index) {
                            final isLast = index == rows.length - 1;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DropdownMenu(
                                      label: const Text("Type"),
                                      controller: rows[index]["type"],
                                      dropdownMenuEntries: const [
                                        DropdownMenuEntry(value: "PETROL", label: "PETROL"),
                                        DropdownMenuEntry(value: "DIESEL", label: "DIESEL"),
                                        DropdownMenuEntry(value: "CNG", label: "CNG"),
                                        DropdownMenuEntry(value: "LPG", label: "LPG")
                                      ],
                                      inputDecorationTheme: InputDecorationTheme(
                                        filled: true,
                                        fillColor: Colors.white,
                                        iconColor: _colors.whiteColour,
                                        suffixIconColor: _colors.whiteColour,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                      ),
                                    ),
                                  ),
                                  UIHelper.horizontalSpaceTiny,
                                  Expanded(
                                    child: TextField(
                                      controller: rows[index]["amount"],
                                      decoration: InputDecoration(
                                        hintText: "Amount",
                                        fillColor: _colors.greenColour1,
                                        filled: true,
                                        prefixText: "₹",
                                        prefixStyle: TextStyle(color: _colors.blackColour),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
                                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  UIHelper.horizontalSpaceTiny,
                                  rows[index]["type"]!.text.isNotEmpty && rows[index]["amount"]!.text.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(
                                            isLast ? Icons.add : Icons.remove,
                                            color: isLast ? Colors.green : Colors.red,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (isLast) {
                                                rows.add({
                                                  "type": TextEditingController(),
                                                  "amount": TextEditingController(),
                                                });
                                              } else {
                                                rows.removeAt(index);
                                              }
                                            });
                                          },
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        List<Map<String, dynamic>> resarray = [];
                        for (var row in rows) {
                          if (row['type']!.text.isNotEmpty && row['amount']!.text.isNotEmpty) {
                            Map<String, dynamic> temp = {"type": row['type']!.text, "amount": row['amount']!.text};
                            resarray.add(temp);
                          }
                        }
                        widget.returnData(resarray);
                        Get.back();
                      },
                      child: Container(
                        width: Get.width / 2,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: UIHelper.roundedBorderWithColor(20, 20, 20, 20, _colors.primarycolour),
                        alignment: Alignment.center,
                        child: UIHelper.titleTxtStyle("Submit", fntcolor: _colors.whiteColour),
                      ),
                    ),
                    UIHelper.verticalSpaceMedium,
                  ],
                ),
              )));
    });
  }
}
