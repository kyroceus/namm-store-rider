import 'package:get/get.dart';
import 'package:nammastore_rider/controller/driver_dashboard_controller.dart';
import 'package:nammastore_rider/controller/socket_controller.dart';
import 'package:nammastore_rider/services/socket_service.dart';

class DriverDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SocketService>(() => SocketService());
    Get.lazyPut<SocketController>(() => SocketController());
    Get.lazyPut<DriverDashboardController>(() => DriverDashboardController());
  }
}
