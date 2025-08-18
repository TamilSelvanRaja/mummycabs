import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mummy_cabs/resources/off_line_screen.dart';
import 'package:mummy_cabs/services/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  InitialBinding().dependencies();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late final Connectivity _connectivity;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();

    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      bool isOffline = results.every((result) => result == ConnectivityResult.none);
      _handleConnectivityChange(isOffline);
    });
  }

  void _handleConnectivityChange(bool isOffline) {
    isOffline ? Get.to(() => NoInternet()) : Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Routes.initial,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
    );
  }
}
