import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/images.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';
import 'package:mummy_cabs/services/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  UIHelper.titleTxtStyle("Sign in to your account", fntcolor: _colors.primarycolour, fntsize: 20),
                  UIHelper.verticalSpaceMedium,
                  CustomInput(hintText: "Mobile Number", fieldname: "mobile", fieldType: "mobile", onchanged: (value) {}, prefixWidget: const Icon(Icons.phone_iphone)),
                  UIHelper.verticalSpaceMedium,
                  CustomInput(hintText: "Password", fieldname: "password", fieldType: "password", onchanged: (value) {}, isPassword: true, prefixWidget: const Icon(Icons.lock)),
                  UIHelper.verticalSpaceMedium,
                  Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          onTap: () {
                            Get.toNamed(Routes.password);
                          },
                          child: UIHelper.titleTxtStyle("Forgot password?", fntcolor: _colors.bluecolor, fntsize: 14))),
                  UIHelper.verticalSpaceMedium,
                  UIHelper().actionButton("Login", 18, Get.width / 2, bgcolour: _colors.primarycolour, onPressed: () async {
                    // dynamic postParams = {
                    //   "service_id": "login",
                    //   "mobile": "8608335666",
                    //   "password": "Mani@123#",
                    // };
                    // AppController().loginFunction(postParams);

                    if (_formKey.currentState!.saveAndValidate()) {
                      Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
                      postParams['service_id'] = "login";
                      AppController().loginFunction(postParams);
                    }
                  }),
                  const Spacer(),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      UIHelper.titleTxtStyle("Dont have an account?", fntcolor: _colors.bluecolor, fntsize: 14),
                      InkWell(
                          onTap: () {
                            Get.toNamed(Routes.signup, arguments: {"isSignup": true});
                          },
                          child: UIHelper.titleTxtStyle(" Register here", fntcolor: _colors.bluecolor, fntsize: 14, fntWeight: FontWeight.bold)),
                    ],
                  ),
                  UIHelper.verticalSpaceMedium,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
