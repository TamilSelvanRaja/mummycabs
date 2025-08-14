import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';

class CustomAlert extends StatefulWidget {
  final dynamic onClickOK;
  final dynamic onBackPress;
  final String title;
  final String message;
  final dynamic subTitle;
  const CustomAlert({super.key, this.onClickOK, this.onBackPress, required this.title, required this.message, this.subTitle});
  @override
  State<CustomAlert> createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();

  Color primary = Colors.white;
  String selectedIcon = "";
  String title = "";

  @override
  void initState() {
    super.initState();
    if (widget.title == "O") {
      primary = _colors.bluecolor;
      title = widget.subTitle;
      selectedIcon = _images.logout;
    } else if (widget.title == "W") {
      primary = _colors.redColour;
      title = "Warning";
      selectedIcon = _images.warning;
    } else {
      primary = _colors.redColour;
      title = widget.subTitle;
      selectedIcon = _images.warning;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        decoration: UIHelper.roundedBorderWithColor(16, 16, 0, 0, primary),
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: (() {
                            Get.back();
                            widget.onBackPress();
                          }),
                          child: Icon(Icons.close_rounded, size: 30, color: _colors.whiteColour),
                        )),
                    const SizedBox(height: 30)
                  ],
                ),
                Positioned(
                    child: Center(
                  child: Container(
                    height: 60,
                    width: 60,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 20),
                    decoration: UIHelper.circleWithColorWithShadow(1, primary, primary, borderColor: _colors.whiteColour, borderWidth: 3),
                    child: Image.asset(selectedIcon, height: 20, width: 20),
                  ),
                ))
              ],
            ),
            UIHelper.verticalSpaceSmall,
            UIHelper.titleTxtStyle(title, fntcolor: primary, fntsize: 18, fntWeight: FontWeight.bold),
            UIHelper.verticalSpaceSmall,
            UIHelper.titleTxtStyle(widget.message, fntcolor: _colors.blackColour, fntsize: 14, fntWeight: FontWeight.bold),
            UIHelper.verticalSpaceMedium,
            UIHelper().actionButton(widget.title == "S" || widget.title == "F" ? "Ok" : "Yes", 16, Get.width / 4, onPressed: () {
              Get.back();
              widget.onClickOK();
            }),
            UIHelper.verticalSpaceMedium
          ],
        ),
      ),
    );
  }
}
