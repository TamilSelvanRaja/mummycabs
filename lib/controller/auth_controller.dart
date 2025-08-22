import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';

class AppController with ChangeNotifier {
  final PreferenceService pref = Get.find<PreferenceService>();
  final AppColors _colors = AppColors();
  List tripsList = [];
  List drivertripsList = [];

//******************************************************************/
//******************* User Register Function ***********************/
//******************************************************************/
  Future userregister(dynamic postParams, String localpath, bool issignup) async {
    final responce = await apiresponceCallback(postParams, localpath);
    if (responce != null) {
      if (responce["msg"].toString() == "true") {
        Get.back();
        if (issignup) {
          Utils().showToast("Success", responce['message'], bgclr: _colors.greenColour);
        }
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
        Get.offNamedUntil(Routes.adminDashboard, (p) => false);
      } else {
        Get.offNamedUntil(Routes.driverDashboard, (p) => false);
      }
    }
  }

//******************************************************************/
//******************** Cart Amount Function *************************/
//******************************************************************/
  Future cartAmountGet(postParams) async {
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      pref.userdata = responce['data'];
      notifyListeners();
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
      } else {
        pref.driversList = responce['data'];
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
      await getcarList("car_list");
      notifyListeners();
    }
  }

//******************************************************************/
//******************* NEW Trip Add Function ***********************/
//******************************************************************/
  Future newTripStart(dynamic postParams) async {
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      if (responce["msg"].toString() == "true") {
        Get.back();
      } else {
        Utils().showToast("Failure", '${responce["message"]}');
      }
    }
  }

//******************************************************************/
//*******************  Get Trip List Function **********************/
//******************************************************************/
  Future gettripList(String date) async {
    tripsList.clear();

    dynamic postParams = {"service_id": "trips_list", "date": date};
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      tripsList = responce['data'];
      notifyListeners();
    }
  }

//******************** Cart Amount Update Function *************************/
//**************************************************************************/
  Future cartAmtUpdateFun(postParams) async {
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      Get.back();
      Utils().showToast("Success", '${responce["message"]}', bgclr: _colors.greenColour);
      for (var i in pref.driversList) {
        if (i["_id"].toString() == postParams['driver_id'].toString()) {
          i['cart_amt'] = "${responce['amount']}";
        }
      }
      notifyListeners();
    }
  }

//******************************************************************/
//*******************  Get Trip List Function **********************/
//******************************************************************/
  Future getdrivertripList(String date) async {
    drivertripsList.clear();

    dynamic postParams = {
      "service_id": "trip_list_driver",
      "driver_id": pref.userdata["_id"],
      "date": date,
    };
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      drivertripsList = responce['data'];
      notifyListeners();
    }
  }

  Future apiresponceCallback(postParams, localpath) async {
    try {
      Utils().showProgress();
      log("postParams $postParams");
      final responce = await ApiServices().formDataAPIServices(postParams, localpath);
      log("responce $responce");
      Utils().hideProgress();

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
