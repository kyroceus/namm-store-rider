import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nammastore_rider/controller/driver_dashboard_controller.dart';

class DriverDashboard extends GetView<DriverDashboardController> {
  const DriverDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Driver"),
        actions: [
          // Connection Status Indicator
          Obx(
            () => Icon(
              Icons.circle,
              color: controller.orderService.isConnected.value
                  ? Colors.green
                  : Colors.red,
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Obx(() {
        if (controller.orderService.orders.isEmpty) {
          return const Center(child: Text("No orders available... waiting"));
        }
        return ListView.builder(
          itemCount: controller.orderService.orders.length,
          itemBuilder: (ctx, i) {
            final order = controller.orderService.orders[i];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(order['restaurant'] ?? 'Unknown Restaurant'),
                subtitle: Text(order['address'] ?? 'Unknown Address'),
                trailing: ElevatedButton(
                  onPressed: () {
                    // Attempt to pick order
                    controller.pickOrder(order['id']);
                  },
                  child: const Text("Accept"),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
