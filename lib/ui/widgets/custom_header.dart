import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/utils.dart';

class CustomHeader extends StatelessWidget {
  CustomHeader({super.key, required this.title});
  final String title;
  final AppColors _colors = AppColors();
  @override
  Widget build(BuildContext context) {
    return Container(
        width: Utils().getWidgetWidth(context),
        height: 80,
        alignment: Alignment.center,
        decoration: UIHelper.roundedBorderWithColor(20, 20, 0, 0, _colors.primarycolour),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: _colors.bgClr,
                )),
            UIHelper.horizontalSpaceMedium,
            UIHelper.titleTxtStyle(title, fntcolor: _colors.whiteColour, fntsize: 30, fntWeight: FontWeight.bold),
          ],
        ));
  }
}
