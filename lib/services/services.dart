import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

//**********************************************/
//************** Service API Call **************/
//**********************************************/
class ApiServices {
  //String apiurl = "https://xaviersxxxgym.com/mummy_cabs";
  String apiurl = "http://10.163.19.180/mummycabs";
  //String apiurl = "http://192.168.1.4/mummy_cabs";

  Future formDataAPIServices(Map<String, dynamic> requestJson, String localPath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$apiurl/api.php"));

      // Add fields
      requestJson.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add file if local
      if (localPath.isNotEmpty) {
        String filename = localPath.split('/').last;
        request.files.add(await http.MultipartFile.fromPath('profile_img', localPath, filename: filename));
      }

      // Send request via IOClient
      var streamedResponse = await request.send();
      var responseString = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        var decodedData = json.decode(responseString);
        return decodedData;
      }
      return null;
    } catch (e) {
      debugPrint("$e");
    }
  }
}

//**********************************************/
//************ Shared Preferences **************/
//**********************************************/
class PreferenceService {
  List paymentTypes = [
    {"reg_no": "Cash"},
    {"reg_no": "G-pay"},
    {"reg_no": "Phone Pay"},
    {"reg_no": "Paytm"}
  ];

  Future setString(key, value) async {
    var box = Hive.box('mummycabs');
    await box.put(key, value);
  }

  Future getString(key) async {
    var box = Hive.box('mummycabs');
    return await box.get(key, defaultValue: "");
  }

  Future setjsonData(key, value) async {
    var box = Hive.box('mummycabs');
    await box.put(key, value);
  }

  Future getjsonData(key) async {
    var box = Hive.box('mummycabs');
    return await box.get(key, defaultValue: {});
  }

  Future setArrayData(key, value) async {
    var box = Hive.box('mummycabs');
    await box.put(key, value);
  }

  Future getArrayData(key) async {
    var box = Hive.box('mummycabs');
    return await box.get(key, defaultValue: []);
  }

//// ************ Clear the local Storage ***********\\\\\
  Future cleanAllPreferences() async {
    final box = Hive.box('mummycabs');
    await box.clear();
  }
}
