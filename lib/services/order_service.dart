import 'package:get/get.dart';
import 'package:nammastore_rider/models/order_model.dart';
import 'package:nammastore_rider/services/http_service.dart';
import 'package:nammastore_rider/services/logger_service.dart';

class OrderService extends GetxService {
  final HttpService _http = HttpService.instance;

  Future<OrderModel?> fetchActiveOrder() async {
    try {
      final response = await _http.request(
        path: '/v1/rider/delivery/active',
        method: 'GET',
        auth: true,
      );

      if (response != null) {
        // Response data is a List based on user input
        if (response is List && response.isNotEmpty) {
          return OrderModel.fromJson(response.first);
        } else if (response is Map<String, dynamic>) {
          // Handle if single object
          return OrderModel.fromJson(response);
        }
      }
      return null;
    } catch (e) {
      AppLogger.instance.e("Error fetching active order: $e");
      return null;
    }
  }

  Future<String?> updateDeliveryStatus(
    String deliveryId,
    String newStatus,
  ) async {
    try {
      await _http.request(
        path: '/v1/rider/delivery/$deliveryId/status',
        method: 'PUT',
        body: {'status': newStatus},
        auth: true,
      );

      // HttpService returns 'data' on success.
      // Assuming existing status return or just success.
      // If the API returns the updated status or object, we can return it.
      // For now, if no error, we return the status we sent, or check response.
      return newStatus;
    } catch (e) {
      AppLogger.instance.e("Error updating delivery status: $e");
      return null;
    }
  }

  Future<List<OrderModel>> fetchDeliveryHistory({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _http.request(
        path: '/v1/rider/delivery/history?page=$page&limit=$limit',
        method: 'GET',
        auth: true,
      );

      if (response != null && response is List) {
        return response
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      AppLogger.instance.e("Error fetching delivery history: $e");
      return [];
    }
  }
}
