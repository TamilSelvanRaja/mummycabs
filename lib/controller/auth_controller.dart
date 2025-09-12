import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/resources/colors.dart';
import 'package:mummy_cabs/services/db_healper.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:mummy_cabs/services/utils.dart';
import 'package:sqflite/sqflite.dart';

class AppController with ChangeNotifier {
  AppController() {
    _init();
  }

  final PreferenceService pref = Get.find<PreferenceService>();
  final AppColors _colors = AppColors();
  String tripdayamount = "0";
  String totalcartamount = "";

  List tripsList = [];
  List drivertripsList = [];
  List transactionList = [];

  List companytripsList = [];

  var dbHelper = DbHelper();
  Database? dbClient;

  Future<void> _init() async {
    dbClient = await dbHelper.db;
    pref.pendingTripList = await dbClient!.rawQuery('SELECT * FROM pendingList');
  }

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
      } else {
        pref.customersList = responce['data'];
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
//*********************** Trip localsave ***************************/
//******************************************************************/
  Future triplocalsave(dynamic postParams) async {
    var count = 0;
    dbClient ??= await dbHelper.db;

    count = await dbClient!.rawInsert('''
  INSERT INTO pendingList (
    trip_date, vehicle_no, driver_id, ola_cash, ola_operator,
    uber_cash, uber_operator, rapido_cash, rapido_operator,
    other_cash, other_operator,duty_desc, total_cash_amt, total_operator_amt,
    salary_percentage, driver_salary, fuel_amt, other_expences,
    other_desc, kilometer, balance_amount, per_km
  )
  VALUES (
  "${postParams["trip_date"]}","${postParams["vehicle_no"]}","${postParams["driver_id"]}","${postParams["ola_cash"]}","${postParams["ola_operator"]}",
    "${postParams["uber_cash"]}","${postParams["uber_operator"]}","${postParams["rapido_cash"]}","${postParams["rapido_operator"]}","${postParams["other_cash"]}",
    "${postParams["other_operator"]}","${postParams["duty_desc"]}","${postParams["total_cash_amt"]}","${postParams["total_operator_amt"]}","${postParams["salary_percentage"]}",
    "${postParams["driver_salary"]}","${postParams["fuel_amt"]}","${postParams["other_expences"]}","${postParams["other_desc"]}","${postParams["kilometer"]}",
    "${postParams["balance_amount"]}","${postParams["per_km"]}"  
  )
''');

    if (count > 0) {
      Get.back();
      pref.pendingTripList = await dbClient!.rawQuery('SELECT * FROM pendingList');
      Utils().showToast("Success", "Successfully created.", bgclr: _colors.greenColour);
    }
  }

//******************************************************************/
//********************* Trip local Update **************************/
//******************************************************************/
  Future tripLocalUpdate(dynamic postParams) async {
    dbClient ??= await dbHelper.db;

    int count = await dbClient!.rawUpdate('''
    UPDATE pendingList SET
      trip_date = ?,
      vehicle_no = ?,
      driver_id = ?,
      ola_cash = ?,
      ola_operator = ?,
      uber_cash = ?,
      uber_operator = ?,
      rapido_cash = ?,
      rapido_operator = ?,
      duty_desc = ?,
      other_cash = ?,
      other_operator = ?,
      total_cash_amt = ?,
      total_operator_amt = ?,
      salary_percentage = ?,
      driver_salary = ?,
      fuel_amt = ?,
      other_expences = ?,
      other_desc = ?,
      kilometer = ?,
      balance_amount = ?,
      per_km = ?
    WHERE uni_id = ?
  ''', [
      postParams["trip_date"],
      postParams["vehicle_no"],
      postParams["driver_id"],
      postParams["ola_cash"],
      postParams["ola_operator"],
      postParams["uber_cash"],
      postParams["uber_operator"],
      postParams["rapido_cash"],
      postParams["rapido_operator"],
      postParams["duty_desc"],
      postParams["other_cash"],
      postParams["other_operator"],
      postParams["total_cash_amt"],
      postParams["total_operator_amt"],
      postParams["salary_percentage"],
      postParams["driver_salary"],
      postParams["fuel_amt"],
      postParams["other_expences"],
      postParams["other_desc"],
      postParams["kilometer"],
      postParams["balance_amount"],
      postParams["per_km"],
      int.parse(postParams['uni_id'].toString())
    ]);

    if (count > 0) {
      pref.pendingTripList = await dbClient!.rawQuery('SELECT * FROM pendingList');
      Get.back();
      Utils().showToast("Success", "Successfully updated.", bgclr: _colors.greenColour);
      notifyListeners();
    }
  }

//******************************************************************/
//********************** Trip local delete *************************/
//******************************************************************/
  Future triplocaldelete(int id) async {
    var count = 0;
    dbClient ??= await dbHelper.db;
    count = await dbClient!.rawDelete('DELETE FROM pendingList WHERE uni_id = ?', [id]);
    if (count > 0) {
      pref.pendingTripList = await dbClient!.rawQuery('SELECT * FROM pendingList');
      Utils().showToast("Deleted", "Trip deleted successfully.", bgclr: _colors.greenColour);
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
        int id = int.parse(postParams['uni_id'].toString());
        await dbClient!.rawDelete("DELETE FROM pendingList WHERE uni_id = ?", [id]);
        pref.pendingTripList = await dbClient!.rawQuery('SELECT * FROM pendingList');
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
      tripdayamount = responce['over_all_amount'].toString();
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
  Future getCompanytripList(String date, String cusId) async {
    companytripsList.clear();

    dynamic postParams = {"service_id": "companytrip_list", "customer_id": cusId, "from_date": date};
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
  Future generateMonthlyReport(String monthyear) async {
    transactionList.clear();

    dynamic postParams = {
      "service_id": "file_generate",
      "from_date": monthyear,
    };
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      Utils().showToast("Success", '${responce["message"]}', bgclr: _colors.greenColour);
    }
  }

//******************************************************************/
//***************  Monthly Report Generate Function ****************/
//******************************************************************/
  Future generateInvoiceReport(String monthyear, String cusid) async {
    transactionList.clear();

    dynamic postParams = {"service_id": "invoice_generate", "from_date": monthyear, "customer_id": cusid};
    final responce = await apiresponceCallback(postParams, "");
    if (responce != null) {
      Utils().showToast("Success", '${responce["message"]}', bgclr: _colors.greenColour);
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
