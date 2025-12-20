import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nammastore_rider/Bindings/onboarding_binding.dart';
import 'package:nammastore_rider/routes/app_pages.dart';
import 'package:nammastore_rider/services/http_service.dart';

import 'package:nammastore_rider/controller/auth_controller.dart';
import 'package:nammastore_rider/controller/otp_controller.dart';
import 'package:nammastore_rider/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  HttpService.init(
    baseUrl: "https://namma-store-backend-staging.onrender.com/api",
  );
  Get.put(AuthService());
  Get.put(AuthController(authService: Get.find<AuthService>()));
  Get.lazyPut(() => OtpController(), fenix: true);

  // Initialize Onboarding dependencies
  OnboardingBinding().dependencies();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final AuthController authController = Get.find<AuthController>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialRoute: Routes.splashScreen,
    );
  }
}
