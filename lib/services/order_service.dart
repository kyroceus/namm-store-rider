import 'dart:convert';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class OrderService extends GetxService {
  late IO.Socket socket;
  // Using RxList for reactive updates
  final orders = <dynamic>[].obs;
  final isConnected = false.obs;

  void initSocket(String token) {
    // RECONNECTION & AUTH CONFIGURATION
    // Replace 'http://YOUR_LOCAL_IP:3000' with your actual server URL
    // For Android emulator use 'http://10.0.2.2:3000'
    // For iOS simulator use 'http://localhost:3000' or your machine's IP
    socket = IO.io(
      'http://192.168.1.35:8080/v1/delivery',
      IO.OptionBuilder()
          .setTransports(['websocket']) // for Flutter or Web
          .disableAutoConnect() // We connect manually
          .setAuth({'token': token}) // AUTH: Send JWT here
          .setReconnectionAttempts(5) // Retry logic
          .build(),
    );

    socket.connect();

    _setupListeners();
  }

  void _setupListeners() {
    socket.onConnect((_) {
      print('Connected to Socket');
      isConnected.value = true;
      socket.emitWithAck(
        'delivery:initial',
        {},
        ack: (response) {
          print(response);
          if (response['success'] == true) {
            orders.assignAll(response['data']);
          }
        },
      );
    });

    socket.onDisconnect((_) {
      print('Disconnected');
      isConnected.value = false;
    });

    socket.on('delivery:new', (data) {
      orders.addAll(data);
    });

    socket.on('delivery:accepted', (response) {
      orders.removeWhere((element) => element['id'] == response.data.deliveryId);
    });
  }

  // Driver attempts to pick an order
  Future<void> pickOrder(String orderId) async {
    // Emit with Ack (callback) to handle success/failure
    socket.emitWithAck(
      'delivery:accept',
      jsonEncode({'deliveryId': orderId}),
      ack: (response) {
        if (response['success'] == true) {
          // Optimistically remove from local list
          orders.removeWhere((element) => element['id'] == orderId);
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
    socket.dispose();
    super.onClose();
  }
}
