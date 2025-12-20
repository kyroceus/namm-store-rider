import 'package:get/get.dart';
import 'package:nammastore_rider/controller/socket_controller.dart';

class DriverDashboardController extends GetxController {
  final SocketController socketController = Get.find<SocketController>();

  @override
  void onInit() {
    super.onInit();
    // Simulate a JWT token login
    final fakeJwt = "eyJhbGciOiJIUzI1NiJ9.USER_PAYLOAD_HERE.SIGNATURE";

    // Initialize Socket
    socketController.init(fakeJwt);
  }

  void pickOrder(String orderId) {
    socketController.pickOrder(orderId);
  }
}
