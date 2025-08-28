import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/utils.dart';

final AppColors _colors = AppColors();

//*******************************************************/
//********* Drop Down Field Class with Validation********/
//*******************************************************/
class CustomDropDown extends StatefulWidget {
  final dynamic onSelected;
  final String hintText;
  final String fieldname;
  final List initList;
  final dynamic initValue;

  const CustomDropDown({super.key, required this.initList, required this.hintText, required this.fieldname, this.onSelected, this.initValue});
  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String keyCode = "reg_no";
  String titleText = "reg_no";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
      name: widget.fieldname,
      initialValue: widget.initValue ?? "",
      decoration: UIHelper.inputDecorateWidget(widget.hintText, null),
      style: UIHelper.customTxtStyle(_colors.blackColour, 14, FontWeight.w400),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value == "" || value == "null") {
          return "${widget.hintText} is required.";
        } else {
          return null;
        }
      },
      items: widget.initList
          .map((item) => DropdownMenuItem(
                alignment: AlignmentDirectional.centerStart,
                value: item[keyCode].toString(),
                child: UIHelper.titleTxtStyle(item[titleText].toString().toUpperCase()),
              ))
          .toList(),
      onChanged: (value) async {
        widget.onSelected(value);
      },
    );
  }
}

//*******************************************************/
//*********** Input Field Class with Validation *********/
//*******************************************************/
class CustomInput extends StatefulWidget {
  final String hintText;
  final String fieldname;
  final String fieldType;
  final dynamic initValue;
  final dynamic isPassword;
  final Widget? prefixWidget;
  final dynamic onchanged;
  const CustomInput({super.key, required this.hintText, required this.fieldname, required this.fieldType, this.onchanged, this.initValue, this.isPassword, this.prefixWidget});
  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool isShow = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  inputValidation(String type, String value) {
    switch (type) {
      case "mobile":
        if (!Utils().isNumberValid(value)) {
          return "${widget.hintText} is Invalid";
        }
        break;
      default:
        return null;
    }
  }

  Widget showIcon() {
    return GestureDetector(
      onTap: () {
        isShow ? isShow = false : isShow = true;
        setState(() {});
      },
      child: Icon(
        isShow ? Icons.visibility : Icons.visibility_off,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      obscureText: isShow,
      textInputAction: TextInputAction.next,
      style: UIHelper.customTxtStyle(_colors.blackColour, 14, FontWeight.w400),
      name: widget.fieldname,
      initialValue: widget.initValue ?? "",
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        if (widget.onchanged != null) {
          widget.onchanged(value);
        }
      },
      decoration: widget.isPassword != null && widget.isPassword
          ? UIHelper.inputDecorateWidget(widget.hintText, widget.prefixWidget, suffixWidget: showIcon())
          : UIHelper.inputDecorateWidget(
              widget.hintText,
              widget.prefixWidget,
            ),
      validator: ((value) {
        if (widget.fieldType != "novalidation") {
          if (value == "" || value == null) {
            return "${widget.hintText} is required";
          } else {
            return inputValidation(widget.fieldType, value);
          }
        }
        return null;
      }),
      inputFormatters: widget.fieldType == "mobile" || widget.fieldType == "number"
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ]
          : widget.fieldType == "aadhar_number"
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ]
              : [],
      keyboardType: widget.fieldType == "mobile" || widget.fieldType == "aadhar_number" || widget.fieldType == "number" ? TextInputType.number : TextInputType.text,
    );
  }
}

//*******************************************************/
//*********** Input Field Class with Validation *********/
//*******************************************************/
class CustomInput1 extends StatefulWidget {
  final String hintText;
  final String fieldname;
  final String fieldType;
  final Widget? prefixWidget;
  final dynamic onchanged;
  final dynamic initValue;

  const CustomInput1({super.key, required this.hintText, required this.fieldname, this.onchanged, this.initValue, required this.fieldType, this.prefixWidget});
  @override
  State<CustomInput1> createState() => _CustomInputState1();
}

class _CustomInputState1 extends State<CustomInput1> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      textInputAction: TextInputAction.next,
      style: UIHelper.customTxtStyle(_colors.blackColour, 14, FontWeight.w400),
      name: widget.fieldname,
      initialValue: widget.initValue ?? "",
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        if (widget.onchanged != null) {
          widget.onchanged(value);
        }
      },
      decoration: UIHelper.inputDecorateWidget(widget.hintText, widget.prefixWidget,
          suffixString: widget.hintText == "Driver Salary"
              ? "%"
              : widget.hintText == "Kilometer"
                  ? "Km"
                  : "₹"),
      validator: ((value) {
        if (widget.fieldType != "novalidation") {
          if (value == "" || value == null) {
            return "${widget.hintText} is required";
          }
        }
        return null;
      }),
      keyboardType: TextInputType.number,
    );
  }
}

//*******************************************************/
//*********** Date Picker Class with Validation *********/
//*******************************************************/
class CustomDatePicker extends StatefulWidget {
  final String hintText;
  final String fieldname;
  final dynamic onSelected;
  final dynamic initValue;
  const CustomDatePicker({super.key, required this.hintText, required this.fieldname, this.onSelected, this.initValue});
  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? initdateTime;
  @override
  void initState() {
    super.initState();
    if (widget.initValue != null && widget.initValue != "") {
      initdateTime = DateFormat("dd-MM-yyyy").parse(widget.initValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      name: widget.fieldname,
      initialValue: initdateTime,
      inputType: InputType.date,
      format: DateFormat('dd-MM-yyyy'),
      style: UIHelper.customTxtStyle(_colors.blackColour, 14, FontWeight.w400),
      timePickerInitialEntryMode: TimePickerEntryMode.dial,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      lastDate: DateTime.now(),
      decoration: UIHelper.inputDecorateWidget(widget.hintText, null, suffixWidget: const Icon(Icons.date_range)),
      validator: (value) {
        if (value == null) {
          return "${widget.hintText} is required.";
        }
        return null;
      },
      onChanged: (value) {
        if (value != null) {
          DateTime inputDate = DateTime.parse(value.toString());
          DateFormat format = DateFormat('dd-MM-yyyy');
          String selectedDate = format.format(inputDate);
          widget.onSelected(selectedDate);
        }
      },
    );
  }
}

class DatePicker extends StatefulWidget {
  final String hintText;
  final String fieldname;
  final dynamic onSelected;
  final dynamic initValue;
  const DatePicker({
    super.key,
    required this.hintText,
    required this.fieldname,
    this.onSelected,
    this.initValue,
  });
  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  String day1 = "";
  String day2 = "";
  String formattedDate = "";
  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      name: widget.fieldname,
      initialValue: widget.initValue,
      inputType: InputType.date,
      format: DateFormat("dd-MM-yyyy"),
      timePickerInitialEntryMode: TimePickerEntryMode.dial,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      lastDate: DateTime.now(),
      decoration: UIHelper.inputDecorateWidget(widget.hintText, null, suffixWidget: const Icon(Icons.date_range)),
      validator: (value) {
        if (value == null) {
          return "${widget.hintText} is required.";
        }
        return null;
      },
      onChanged: (value) {
        if (value != null) {
          DateTime inputDate = DateTime.parse(value.toString());
          DateFormat format = DateFormat('dd-MM-yyyy');
          formattedDate = format.format(inputDate);
          DateTime currentDate = DateTime.now();
          String formattedCurrentDate = format.format(currentDate);
          if (formattedDate == formattedCurrentDate) {
            widget.onSelected();
          } else {
            widget.onSelected(formattedDate);
          }
        }
        setState(() {});
      },
    );
  }
}
