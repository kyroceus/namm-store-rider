import 'package:get/get.dart';
import 'package:nammastore_rider/models/transaction_model.dart';
import 'package:nammastore_rider/services/http_service.dart';
import 'package:nammastore_rider/services/logger_service.dart';

class TransactionService extends GetxService {
  final HttpService _http = HttpService.instance;

  Future<List<TransactionModel>> fetchTransactions({
    required String type,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _http.request(
        path:
            '/v1/rider/transaction/history?page=$page&limit=$limit&type=$type',
        method: 'GET',
        auth: true,
      );

      if (response != null && response is List) {
        return response
            .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      AppLogger.instance.e("Error fetching transactions: $e");
      return [];
    }
  }
}
