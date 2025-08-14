import 'dart:convert';
import 'dart:developer';

import 'package:flutter/animation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/io_client.dart';
import 'package:mummy_cabs/services/utils.dart';
import 'package:mummy_cabs/ui/admin/admin_dashboard.dart';
import 'package:mummy_cabs/ui/admin/car_detail.dart';
import 'package:mummy_cabs/ui/admin/driver_detail.dart';
import 'package:mummy_cabs/ui/admin/start_trip.dart';
import 'package:mummy_cabs/ui/auth/password_screen.dart';
import 'package:mummy_cabs/ui/auth/signin_screen.dart';
import 'package:mummy_cabs/ui/auth/signup_screen.dart';
import 'package:mummy_cabs/ui/auth/splash_screen.dart';
import 'package:http/http.dart' as http;

//**********************************************/
//************** Routes String *****************/
//**********************************************/
class Routes {
  static String initial = '/';
  static String login = '/login';
  static String signup = '/signup';
  static String password = '/password';

  static String adminDashboard = '/adminDashboard';
  static String starttrip = '/starttrip';
  static String cardetails = '/cardetails';
  static String driverdetails = '/driverdetails';
}

//**********************************************/
//************** App Redirect Pages ************/
//**********************************************/
abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.initial, page: () => const SplashScreen()),
    pageanimation(Routes.login, const LoginScreen(), Transition.fadeIn),
    pageanimation(Routes.signup, const SignupScreen(), Transition.rightToLeftWithFade),
    pageanimation(Routes.password, const ForgotPasswordScreen(), Transition.rightToLeftWithFade),
    pageanimation(Routes.adminDashboard, const AdminDashboard(), Transition.circularReveal),
    pageanimation(Routes.starttrip, const StartTripScreen(), Transition.rightToLeftWithFade),
    pageanimation(Routes.cardetails, const CarDetailsScreen(), Transition.rightToLeftWithFade),
    pageanimation(Routes.driverdetails, const DriverDetailsScreen(), Transition.rightToLeftWithFade),
  ];

  static GetPage pageanimation(routename, redirectto, animateStyle) {
    return GetPage(
      name: routename,
      page: () => redirectto,
      transition: animateStyle,
      transitionDuration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }
}

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(PreferenceService());
    Get.put(ApiServices());
  }
}

//**********************************************/
//************** Service API Call **************/
//**********************************************/
class ApiServices extends GetConnect {
  String apiurl = "http://10.163.19.180/mummy_cabs";
  ApiServices();
  IOClient ioClient = IOClient();

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
      var streamedResponse = await ioClient.send(request);
      var responseString = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode == 200) {
        var decodedData = json.decode(responseString);
        return decodedData;
      }
      return null;
    } catch (e) {
      Utils().showToast("Failure", "Error : $e");
    }
  }
}

//**********************************************/
//************ Shared Preferences **************/
//**********************************************/
class PreferenceService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  dynamic userdata = {};
  List carList = [];
//// ************ Set User Info ***********\\\\\
  Future<void> setString(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

//// ************ Get User Info ***********\\\\\
  Future<String> getString(String key) async {
    String getStr = await _storage.read(key: key) ?? '';
    if (getStr != '') {
      return getStr;
    }
    return '';
  }

//// ************ Clear the local Storage ***********\\\\\
  Future cleanAllPreferences() async {
    _storage.deleteAll();
  }
}
