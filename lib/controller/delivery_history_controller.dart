import 'package:get/get.dart';
import 'package:nammastore_rider/models/order_model.dart';
import 'package:nammastore_rider/services/order_service.dart';

class DeliveryHistoryController extends GetxController {
  final OrderService _orderService = Get.find<OrderService>();

  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;
  var page = 1;
  var hasMore = true;
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory({bool refresh = false}) async {
    if (isLoading.value) return;

    if (refresh) {
      page = 1;
      hasMore = true;
      orders.clear();
    }

    if (!hasMore) return;

    isLoading.value = true;
    try {
      final newOrders = await _orderService.fetchDeliveryHistory(
        page: page,
        limit: limit,
      );

      if (newOrders.isEmpty || newOrders.length < limit) {
        hasMore = false;
      }

      orders.addAll(newOrders);
      page++;
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }
}
