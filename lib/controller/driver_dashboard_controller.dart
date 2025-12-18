import 'package:get/get.dart';
import 'package:nammastore_rider/services/order_service.dart';

class DriverDashboardController extends GetxController {
  final OrderService orderService = Get.find<OrderService>();

  @override
  void onInit() {
    super.onInit();
    // Simulate a JWT token login
    final fakeJwt = "eyJhbGciOiJIUzI1NiJ9.USER_PAYLOAD_HERE.SIGNATURE";

    // Initialize Socket
    orderService.initSocket(fakeJwt);
  }

  void pickOrder(String orderId) {
    orderService.pickOrder(orderId);
  }
}
