import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nammastore_rider/controller/delivery_history_controller.dart';
import 'package:nammastore_rider/routes/app_pages.dart';
import 'package:nammastore_rider/models/order_model.dart'; // Ensure correct import

class DeliveryHistoryScreen extends StatelessWidget {
  const DeliveryHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject controller if not already present, or use GetView logic
    final controller = Get.put(DeliveryHistoryController());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Delivery History",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return const Center(child: Text("No delivery history found."));
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchHistory(refresh: true),
          child: ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: controller.orders.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.orders.length) {
                // Loader at bottom
                return controller.hasMore
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () => controller.fetchHistory(),
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Load More"),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              }

              final order = controller.orders[index];
              return _buildHistoryCard(order);
            },
          ),
        );
      }),
    );
  }

  Widget _buildHistoryCard(OrderModel order) {
    final date = order.dateCreated != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(order.dateCreated!)
        : "Unknown Date";

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #${order.number ?? '---'}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: (order.status.value == 'DELIVERED')
                      ? Colors.green.shade50
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  order.status.value,
                  style: TextStyle(
                    color: (order.status.value == 'DELIVERED')
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (order.amount != null)
            Text(
              "Amount: ₹${order.amount}",
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
        ],
      ),
    );
  }
}
