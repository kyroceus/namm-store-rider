import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/controller/order_controller.dart';
import 'package:nammastore_rider/controller/socket_controller.dart';
import 'package:nammastore_rider/controller/auth_controller.dart';

class DriverDashboardController extends GetxController {
  final SocketController socketController = Get.find<SocketController>();
  final OrderController orderController = Get.put(OrderController());
  final AuthController authController = Get.find<AuthController>();

  var isOnline = true.obs;
  var selectedDate = DateTime.now().obs;
  var currentBottomNavIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Simulate a JWT token login
    final fakeJwt = "eyJhbGciOiJIUzI1NiJ9.USER_PAYLOAD_HERE.SIGNATURE";

    // Initialize Socket (setups listeners)
    socketController.init(fakeJwt);

    // Initial state check
    if (isOnline.value) {
      socketController.connect();
    } else {
      socketController.disconnect();
    }
  }

  void toggleStatus(bool online) {
    isOnline.value = online;
    if (online) {
      socketController.connect();
    } else {
      socketController.disconnect();
    }
  }

  void updateDate(DateTime date) {
    selectedDate.value = date;
    // Todo: Fetch orders for date
  }

  void changeBottomNavIndex(int index) {
    currentBottomNavIndex.value = index;
  }

  Future<void> pickOrder(String orderId) async {
    if (orderController.hasActiveOrder) {
      Get.snackbar(
        "Active Order",
        "Please complete your active order before picking a new one.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    await socketController.pickOrder(orderId);
    // After picking, we might want to refresh active order or set it manually
    // Assuming socket success means we have the order:
    // Ideally socket returns the new order object, we can set it.
    // For now, let's just fetch active order again to be sure.
    orderController.fetchActiveOrder();
  }
}
