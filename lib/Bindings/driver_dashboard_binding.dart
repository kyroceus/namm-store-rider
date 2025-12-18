import 'package:get/get.dart';
import 'package:nammastore_rider/controller/driver_dashboard_controller.dart';
import 'package:nammastore_rider/services/order_service.dart';

class DriverDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderService>(() => OrderService());
    Get.lazyPut<DriverDashboardController>(() => DriverDashboardController());
  }
}
