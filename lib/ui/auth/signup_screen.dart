import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mummy_cabs/controller/auth_controller.dart';
import 'package:mummy_cabs/controller/camera_controller.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/resources/input_fields.dart';
import 'package:mummy_cabs/resources/ui_helper.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  ImageController imageController = ImageController();
  final AppColors _colors = AppColors();
  String profileUrl = "";
  bool? isSignup;
  @override
  void initState() {
    super.initState();
    isSignup = Get.arguments["isSignup"];
  }

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
                  UIHelper.titleTxtStyle("Welcome !", fntcolor: _colors.primarycolour, fntsize: 22, fntWeight: FontWeight.bold),
                  UIHelper.titleTxtStyle(isSignup! ? "Signup to your account" : "Register a new Driver", fntcolor: _colors.primarycolour, fntsize: 20),
                  UIHelper.verticalSpaceMedium,
                  GestureDetector(
                    onTap: () async {
                      await showModalBottomSheet(
                        context: context,
                        builder: (builder) => bottomSheet(context),
                        isDismissible: true,
                      );
                      setState(() {});
                    },
                    child: Center(
                      child: profileUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: profileUrl.startsWith("https")
                                  ? Image.network(
                                      profileUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(profileUrl),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                            )
                          : const CircleAvatar(
                              radius: 56,
                              child: Icon(
                                Icons.person_rounded,
                                size: 56,
                              ),
                            ),
                    ),
                  ),
                  UIHelper.verticalSpaceSmall,
                  CustomInput(hintText: "Name", fieldname: "name", fieldType: "name", onchanged: (value) {}, prefixWidget: const Icon(Icons.person)),
                  UIHelper.verticalSpaceSmall,
                  CustomInput(hintText: "Mobile Number", fieldname: "mobile", fieldType: "mobile", onchanged: (value) {}, prefixWidget: const Icon(Icons.phone_iphone)),
                  UIHelper.verticalSpaceSmall,
                  CustomInput(hintText: "Driving Licence No", fieldname: "dl_no", fieldType: "text", onchanged: (value) {}, prefixWidget: const Icon(Icons.directions_car_outlined)),
                  UIHelper.verticalSpaceSmall,
                  CustomInput(hintText: "Aadhar Number", fieldname: "aadhar_no", fieldType: "aadhar_number", onchanged: (value) {}, prefixWidget: const Icon(Icons.credit_card_outlined)),
                  UIHelper.verticalSpaceSmall,
                  CustomInput(hintText: "Password", fieldname: "password", fieldType: "password", onchanged: (value) {}, isPassword: true, prefixWidget: const Icon(Icons.lock)),
                  UIHelper.verticalSpaceMedium,
                  UIHelper().actionButton("Submit", 18, Get.width / 2, bgcolour: _colors.primarycolour, onPressed: () {
                    if (_formKey.currentState!.saveAndValidate()) {
                      Map<String, dynamic> postParams = Map.from(_formKey.currentState!.value);
                      postParams['service_id'] = "register";
                      postParams['role'] = "Driver";
                      AppController().userregister(postParams, profileUrl, isSignup!);
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

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100.0,
      width: Get.width,
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.camera),
                onPressed: () async {
                  var path = await imageController.goToCameraScreen(context, ImageSource.camera);
                  if (path != null) {
                    profileUrl = path;
                  }
                  Get.back();
                },
                label: const Text("Camera"),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image),
                onPressed: () async {
                  var path = await imageController.goToCameraScreen(context, ImageSource.gallery);
                  if (path != null) {
                    profileUrl = path;
                  }
                  Get.back();
                },
                label: const Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
