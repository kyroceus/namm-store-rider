import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/services/http_service.dart';

import 'controller/auth_controller.dart';
import 'controller/otp_controller.dart';
import 'routes/app_pages.dart';
import 'services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpService.init(
    baseUrl: "https://namma-store-backend-staging.onrender.com/api",
  );
  Get.put(AuthService());
  Get.put(AuthController(authService: Get.find<AuthService>()));
  Get.lazyPut(() => OtpController(), fenix: true);

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
      initialRoute: authController.token.isNotEmpty
          ? Routes.loginScreen
          : Routes.driverDashboard,
    );
  }
}
