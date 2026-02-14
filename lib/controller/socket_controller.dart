import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:nammastore_rider/controller/auth_controller.dart';
import 'package:nammastore_rider/controller/order_controller.dart';
import 'package:nammastore_rider/models/order_model.dart';
import 'package:nammastore_rider/services/logger_service.dart';
import 'package:nammastore_rider/services/socket_service.dart';

class SocketController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();

  final orders = <OrderModel>[].obs;
  final isConnected = false.obs;

  void init(String token) {
    socketService.initSocket(token);
    _setupListeners();
    // socketService.connect(); // Wait for online toggle? Or default connect?
    // Usually init connects. Let's keep it connecting for setup and then handle toggle.
    // Or better, move connect out of init if we want explicit control.
    // But user code calls init from DashboardController.
    // Let's defer connection to explicit call or keep it here and let toggle handle it.
    // I will add the methods first.
    socketService.connect();
  }

  void connect() {
    socketService.connect();
  }

  void disconnect() {
    socketService.disconnect();
  }

  void _setupListeners() {
    socketService.onConnect((_) {
      debugPrint('Connected to Socket');
      isConnected.value = true;
      socketService.emitWithAck(
        'delivery:initial',
        {},
        ack: (response) {
          AppLogger.instance.i(response.toString());
          if (response['success'] == true) {
            orders.assignAll(response['data']);
          }
        },
      );
    });

    socketService.onDisconnect((_) {
      debugPrint('Disconnected');
      isConnected.value = false;
    });

    socketService.on('delivery:new', (data) {
      if (data != null) {
        if (data is List) {
          orders.addAll(data.cast<OrderModel>());
        } else {
          orders.add(data as OrderModel);
        }
      }
    });

    socketService.on('delivery:status_change', (response) {
      // response might be a Map or object depending on server implementation.
      // Based on previous code: response.data.deliveryId looks like it was using a model,
      // but the original code treated response as 'dynamic' in some places and map in others.
      // The original code:
      // socket.on('delivery:accepted', (response) {
      //   orders.removeWhere(
      //     (element) => element['id'] == response.data.deliveryId,
      //   );
      // });
      // Wait, 'response.data.deliveryId' implies 'response' is an object?
      // In JS/Dart socket.io, data is usually a Map <String, dynamic>.
      // Let's assume response is a Map.
      AppLogger.instance.i(response);
      final activeDelivery = Get.find<OrderController>().activeOrder.value;
      AppLogger.instance.i(activeDelivery);

      final deliveryId =
          response['data']?['deliveryId'] ?? response['deliveryId'];
      final newStatus = response['data']?['newStatus'] ?? response['newStatus'];
      AppLogger.instance.i(deliveryId + activeDelivery?.id + newStatus);
      if (deliveryId != null &&
          activeDelivery != null &&
          activeDelivery.id == deliveryId) {
        activeDelivery.status.value = newStatus;
      }
    });

    socketService.on('delivery:accepted', (response) {
      // response might be a Map or object depending on server implementation.
      // Based on previous code: response.data.deliveryId looks like it was using a model,
      // but the original code treated response as 'dynamic' in some places and map in others.
      // The original code:
      // socket.on('delivery:accepted', (response) {
      //   orders.removeWhere(
      //     (element) => element['id'] == response.data.deliveryId,
      //   );
      // });
      // Wait, 'response.data.deliveryId' implies 'response' is an object?
      // In JS/Dart socket.io, data is usually a Map <String, dynamic>.
      // Let's assume response is a Map.

      final deliveryId =
          response['data']?['deliveryId'] ?? response['deliveryId'];
      final riderId = response['data']?['riderId'] ?? response['riderId'];
      if (deliveryId != null) {
        orders.removeWhere((element) => element.id == deliveryId);
      }
      if (riderId != Get.find<AuthController>().userId.value) {
        Get.find<OrderController>().fetchActiveOrder();
      }
    });
  }

  // Driver attempts to pick an order
  Future<void> pickOrder(String orderId) async {
    // Emit with Ack (callback) to handle success/failure
    socketService.emitWithAck(
      'delivery:accept',
      jsonEncode({
        'deliveryId': orderId,
        'riderId': Get.find<AuthController>().user.value?.id,
      }),

      ack: (response) {
        if (response['success'] == true) {
          // Optimistically remove from local list
          orders.removeWhere((element) => element.id == orderId);
          Get.snackbar(
            "Success",
            "You got the order!",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "Failed",
            "Too slow! Order taken.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
    );
  }

  @override
  void onClose() {
    // Usually we don't dispose service here as it might be persistent,
    // but if this controller owns the socket lifecycle, we might disconnect.
    // For now, let's just leave the service running or disconnect if needed.
    // socketService.disconnect();
    super.onClose();
  }
}
