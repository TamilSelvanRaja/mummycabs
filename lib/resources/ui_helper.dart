import 'package:flutter/material.dart';
import 'package:mummy_cabs/resources/colors.dart';

final AppColors _colors = AppColors();

class UIHelper {
  // Vertically Space Provider
  static const Widget verticalSpaceTiny = SizedBox(height: 4.0);
  static const Widget verticalSpaceSmall = SizedBox(height: 10.0);
  static const Widget verticalSpaceMedium = SizedBox(height: 20.0);
  static const Widget verticalSpaceMedium2 = SizedBox(height: 30.0);
  static const Widget verticalSpaceLarge = SizedBox(height: 60.0);
  static const Widget verticalSpaceVeryLarge = SizedBox(height: 130.00);

// Horizontal Space provider
  static const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
  static const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
  static const Widget horizontalSpaceMedium = SizedBox(width: 20.0);
  static const Widget horizontalSpaceMedium2 = SizedBox(width: 30.0);
  static const Widget horizontalSpaceLarge = SizedBox(width: 40.0);

// Input Box Style Provider
  static OutlineInputBorder getInputBorder(double width, {double radius = 15, Color borderColor = Colors.transparent}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(color: borderColor, width: width),
    );
  }

// Form builder Input Fields Decoration
  static InputDecoration inputDecorateWidget(String labelText, final prefixWidget, {final suffixWidget, String suffixString = ""}) {
    return InputDecoration(
      labelText: labelText,
      suffixIcon: suffixWidget,
      prefixIcon: prefixWidget,
      suffixText: suffixString,
      labelStyle: customTxtStyle(_colors.blackColour, 11, FontWeight.w600),
      filled: true,
      counterText: '',
      fillColor: Colors.white,
      enabledBorder: getInputBorder(1, borderColor: _colors.blackColour),
      focusedBorder: getInputBorder(1, borderColor: _colors.blackColour),
      focusedErrorBorder: getInputBorder(1, borderColor: _colors.redColour),
      errorBorder: getInputBorder(1, borderColor: _colors.redColour),
      disabledBorder: getInputBorder(1, borderColor: _colors.blackColour),
      errorStyle: customTxtStyle(_colors.redColour, 10, FontWeight.normal),
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    );
  }

// Text and Style Provider
  static Widget titleTxtStyle(
    String title, {
    double fntsize = 12,
    Color fntcolor = Colors.black,
    FontWeight fntWeight = FontWeight.normal,
    TextOverflow textOverflow = TextOverflow.ellipsis,
    TextAlign txtAlign = TextAlign.left,
  }) {
    return Text(title, overflow: textOverflow, style: customTxtStyle(fntcolor, fntsize, fntWeight), textAlign: txtAlign);
  }

  static TextStyle customTxtStyle(Color fntcolor, double fntsize, FontWeight fntWeight) {
    return TextStyle(color: fntcolor, fontSize: fntsize, fontWeight: fntWeight, fontFamily: 'Poppins');
  }

//Container Style Provider
  static BoxDecoration roundedBorderWithColor(double topleft, double topright, double btmleft, double btmright, Color backgroundColor,
      {double borderWidth = 1, bool isShadow = false, bool isleftBorderOnly = false, Color shadowColor = Colors.black45, Color borderColor = Colors.transparent}) {
    return BoxDecoration(
        borderRadius: BorderRadius.only(topRight: Radius.circular(topright), topLeft: Radius.circular(topleft), bottomLeft: Radius.circular(btmleft), bottomRight: Radius.circular(btmright)),
        border: isleftBorderOnly
            ? Border(
                right: const BorderSide(color: Colors.transparent, width: 0),
                left: BorderSide(color: borderColor, width: borderWidth),
                top: const BorderSide(color: Colors.transparent, width: 0),
                bottom: const BorderSide(color: Colors.transparent, width: 0),
              )
            : Border.all(width: borderWidth, color: borderColor),
        color: backgroundColor,
        boxShadow: isShadow
            ? [
                BoxShadow(
                  color: shadowColor,
                  offset: const Offset(0.8, 1),
                  blurRadius: 8.0,
                )
              ]
            : []);
  }

//Gradient Container Style Provider
  static BoxDecoration gradientContainer(double topleft, double topright, double btmleft, double btmright, List<Color> c1,
      {Color borderColor = Colors.transparent, double borderWidth = 0, double stop1 = 0.1, double stop2 = 1.0}) {
    return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            stop1,
            stop2,
          ],
          colors: c1),
      border: Border.all(color: borderColor, width: borderWidth),
      borderRadius: BorderRadius.only(topRight: Radius.circular(topright), topLeft: Radius.circular(topleft), bottomLeft: Radius.circular(btmleft), bottomRight: Radius.circular(btmright)),
    );
  }

//Circle Container Style Provider
  static BoxDecoration circleWithColorWithShadow(double radius, Color backgroundColor, Color backgroundColor2, {Color borderColor = Colors.transparent, double borderWidth = 1}) {
    return BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: borderWidth, color: borderColor),
        gradient: LinearGradient(
            colors: [
              backgroundColor,
              backgroundColor2,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: const [0.0, 1.0],
            tileMode: TileMode.clamp),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(2, 2),
            blurRadius: 3.0,
          )
        ]);
  }

  //Action Button Style Provider
  GestureDetector actionButton(String btnText, double fs, double wid, {required Function onPressed, bool withoutBG = false, Color bgcolour = Colors.black}) {
    return GestureDetector(
        onTap: () {
          onPressed();
        },
        child: Container(
            decoration: withoutBG ? null : UIHelper.roundedBorderWithColor(8, 8, 8, 8, bgcolour),
            padding: const EdgeInsets.all(10),
            width: wid,
            alignment: Alignment.center,
            child: UIHelper.titleTxtStyle(btnText, fntsize: fs, fntcolor: _colors.bgClr, fntWeight: FontWeight.bold)));
  }
}
