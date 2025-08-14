import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';

class AppController with ChangeNotifier {
  final PreferenceService pref = Get.find<PreferenceService>();
  final AppColors _colors = AppColors();

//******************************************************************/
//******************* User Register Function ***********************/
//******************************************************************/
  Future userregister(dynamic postParams, String localpath, bool isAdminadd) async {
    final responce = await apiresponceCallback(postParams, localpath);
    if (responce != null) {
      if (responce["msg"].toString() == "true") {
        Get.back();
        Utils().showToast("Success", responce['message'], bgclr: _colors.greenColour);
      } else {
        Utils().showToast("Failure", '${responce["message"]}');
      }
    }
  }

//******************************************************************/
//******************** User Login Function *************************/
//******************************************************************/
  Future loginFunction(postParams) async {
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      pref.userdata = responce['data'];
      await pref.setString("mobile", responce['data']['mobile']);
      await pref.setString("password", responce['data']['password']);

      if (responce['data']['role'] == "Admin") {
        Get.toNamed(Routes.adminDashboard);
      }
    }
  }

//******************************************************************/
//***************** Forgot Password Function ***********************/
//******************************************************************/
  Future forgotpassword(postParams) async {
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      Get.back();
      Utils().showToast("Success", responce['message'], bgclr: _colors.greenColour);
    }
  }

//******************************************************************/
//*******************  Get Car List Function ***********************/
//******************************************************************/
  Future getcarList(String searchkey) async {
    dynamic postParams = {"service_id": searchkey};
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      if (searchkey == "car_list") {
        pref.carList = responce['data'];
      }
      notifyListeners();
    }
  }

//******************** New Car Function *************************/
//******************************************************************/
  Future newaddcar(postParams) async {
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      Get.back();
      pref.carList.add(responce['data']);
      notifyListeners();
    }
  }

//******************** New Car Function *************************/
//******************************************************************/
  Future deactivatecar(postParams) async {
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      Get.back();
      await getcarList("car_list");
      notifyListeners();
    }
  }

  Future apiresponceCallback(postParams, localpath) async {
    try {
      Utils().showProgress();
      final responce = await ApiServices().formDataAPIServices(postParams, localpath);
      Utils().hideProgress();

      log("responce :$responce");
      if (responce != null) {
        if (responce["msg"].toString() == "true") {
          return responce;
        } else {
          Utils().showToast("Failure", '${responce["message"]}');
        }
      }
      return null;
    } catch (e) {
      Utils().showToast("Failure", "Error : $e");
    } finally {}
  }
}
