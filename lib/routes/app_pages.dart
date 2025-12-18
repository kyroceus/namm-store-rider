import 'package:get/get.dart';
import 'package:nammastore_rider/Bindings/auth_bindings.dart';
import 'package:nammastore_rider/screens/home_screen.dart';
import 'package:nammastore_rider/screens/login_screen.dart';
import 'package:nammastore_rider/screens/driver_dashboard.dart';
import 'package:nammastore_rider/Bindings/driver_dashboard_binding.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.loginScreen,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),

    GetPage(name: Routes.homeScreen, page: () => HomeScreen()),
    GetPage(
      name: Routes.driverDashboard,
      page: () => const DriverDashboard(),
      binding: DriverDashboardBinding(),
    ),
  ];
}
