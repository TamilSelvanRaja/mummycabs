import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';

class AppController with ChangeNotifier {
  AppController() {
    _init();
  }

  final PreferenceService pref = Get.find<PreferenceService>();
  final AppColors _colors = AppColors();
  String tripdayamount = "0";
  String totalcartamount = "";

  List tripsList = [];
  List pendingtripsList = [];

  List drivertripsList = [];
  List transactionList = [];
  List companytripsList = [];

  Future<void> _init() async {}

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
    } else {
      pref.cleanAllPreferences();
      Get.offNamedUntil(Routes.initial, (p) => false);
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
      } else if (searchkey == "drivers_list") {
        pref.driversList = responce['data'];
        double amount = double.parse("${responce['total_amount']}");
        totalcartamount = amount.toStringAsFixed(2);
      } else if (searchkey == "customer_list") {
        pref.customersList = responce['data'];
      } else {
        pref.dutyDetails = responce['data'];
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

//******************** New Customer Function *************************/
//******************************************************************/
  Future newcustomeradd(postParams) async {
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      Get.back();
      pref.customersList.add(responce['data']);
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

//******************** New Car Function *************************/
//******************************************************************/
  Future dutyDetailsUpdate(postParams) async {
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      Get.back();
      Utils().showToast("Success", 'Data updated successfully', bgclr: _colors.greenColour);
      pref.dutyDetails = responce['data'];
      notifyListeners();
    }
  }

  //******************************************************************/
//******************* NEW Trip Add Function ***********************/
//******************************************************************/
  Future tripSubmission(dynamic postParams) async {
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      if (responce["msg"].toString() == "true") {
        Get.back();
        Utils().showToast("Success", '${responce["message"]}', bgclr: _colors.greenColour);
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
      tripdayamount = responce['over_all_amount'].toString();
      notifyListeners();
    }
  }

//******************************************************************/
//*******************  Get Trip List Function **********************/
//******************************************************************/
  Future getpendingtripList() async {
    pendingtripsList.clear();

    dynamic postParams = {"service_id": "pending_tripList"};
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      pendingtripsList = responce['data'];
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

//******************************************************************/
//****************  Get Transaction List Function ******************/
//******************************************************************/
  Future gettransactionList(String driverid) async {
    transactionList.clear();

    dynamic postParams = {
      "service_id": "transaction_history",
      "driver_id": driverid,
    };
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      transactionList = responce['data'];
      notifyListeners();
    }
  }

//******************************************************************/
//*******************  Get Trip List Function **********************/
//******************************************************************/
  Future getCompanytripList(String from, String to, String cusId) async {
    companytripsList.clear();

    dynamic postParams = {"service_id": "companytrip_list", "customer_id": cusId, "from_date": from, "to_date": to};
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      companytripsList = responce['data'];
      tripdayamount = responce['over_all_amount'].toString();
      notifyListeners();
    }
  }

//******************************************************************/
//******************* NEW Trip Add Function ***********************/
//******************************************************************/
  Future newCompanyTripStart(dynamic postParams) async {
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
//***************  Monthly Report Generate Function ****************/
//******************************************************************/
  Future generateMonthlyReport(String from, String to) async {
    transactionList.clear();

    dynamic postParams = {"service_id": "file_generate", "from_date": from, "to_date": to};
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      Utils().showToast("Success", '${responce["message"]}', bgclr: _colors.greenColour);
    }
  }

//******************************************************************/
//***************  Monthly Report Generate Function ****************/
//******************************************************************/
  Future generateInvoiceReport(String fromDate, String toDate, String cusid) async {
    transactionList.clear();

    dynamic postParams = {"service_id": "invoice_generate", "from_date": fromDate, "to_date": toDate, "customer_id": cusid};
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      Utils().showToast("Success", '${responce["message"]}', bgclr: _colors.greenColour);
    }
  }

//******************************************************************/
//***************  Delete Trip Function ****************/
//******************************************************************/
  Future deleteTrip(dynamic postParams) async {
    final responce = await apiresponceCallback(postParams, "");
  }

  Future apiresponceCallback(postParams, localpath) async {
    log("$postParams");
    Utils().showProgress();
    try {
      final responce = await ApiServices().formDataAPIServices(postParams, localpath);

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
    } finally {
      Utils().hideProgress();
    }
  }
}
