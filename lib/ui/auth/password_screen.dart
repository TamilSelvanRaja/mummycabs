import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final AppColors _colors = AppColors();
  final AppImages _images = AppImages();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.bgClr,
      body: SizedBox(
        height: Get.height,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            height: Get.height,
            width: Get.width,
            child: FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  const Spacer(),
                  Image.asset(_images.logo, height: 100, width: 100),
                  UIHelper.verticalSpaceSmall,
                  UIHelper.titleTxtStyle("Hello Again!", fntcolor: _colors.primarycolour, fntsize: 22, fntWeight: FontWeight.bold),
                  UIHelper.titleTxtStyle("Change your password", fntcolor: _colors.primarycolour, fntsize: 20),
                  const Spacer(),
                  CustomInput(hintText: "Mobile Number", fieldname: "mobile", fieldType: "mobile", onchanged: (value) {}, prefixWidget: const Icon(Icons.phone_iphone)),
                  UIHelper.verticalSpaceMedium,
                  CustomInput(hintText: "New Password", fieldname: "password", fieldType: "password", onchanged: (value) {}, isPassword: true, prefixWidget: const Icon(Icons.lock)),
                  UIHelper.verticalSpaceMedium,
                  CustomInput(hintText: "Confirm Password", fieldname: "confirmpassword", fieldType: "password", onchanged: (value) {}, isPassword: true, prefixWidget: const Icon(Icons.lock)),
                  UIHelper.verticalSpaceMedium,
                  UIHelper().actionButton("Submit", 18, Get.width / 2, bgcolour: _colors.primarycolour, onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
                      if (postParams['password'] == postParams['confirmpassword']) {
                        postParams['service_id'] = "forgot_password";
                        AppController().forgotpassword(postParams);
                      } else {
                        Utils().showAlert("W", "Password does not match");
                      }
                    }
                  }),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
