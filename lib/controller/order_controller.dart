import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/models/order_model.dart';
import 'package:nammastore_rider/services/order_service.dart';
import 'package:nammastore_rider/services/logger_service.dart';

class OrderController extends GetxController {
  final OrderService _orderService = Get.put(
    OrderService(),
  ); // Or Get.find if put elsewhere

  final activeOrder = Rxn<OrderModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActiveOrder();
  }

  Future<void> fetchActiveOrder() async {
    isLoading.value = true;
    try {
      final order = await _orderService.fetchActiveOrder();
      activeOrder.value = order;
      if (order != null) {
        AppLogger.instance.i("Active order found: ${order.id}");
      }
    } catch (e) {
      AppLogger.instance.e("Failed to fetch active order", error: e);
    } finally {
      isLoading.value = false;
    }
  }

  bool get hasActiveOrder => activeOrder.value != null;

  void clearActiveOrder() {
    activeOrder.value = null;
  }

  Future<void> updateOrderStatus(String status) async {
    final order = activeOrder.value;
    if (order == null || order.id == null) return;

    isLoading.value = true;
    try {
      final updatedStatus = await _orderService.updateDeliveryStatus(
        order.id!,
        status,
      );

      if (updatedStatus != null) {
        // Refresh active order to get updated details
        await fetchActiveOrder();

        Get.snackbar(
          "Success",
          "Order status updated to $updatedStatus",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception("Failed to update status");
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update status: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
