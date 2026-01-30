import 'package:get/get.dart';
import 'package:nammastore_rider/models/transaction_model.dart';
import 'package:nammastore_rider/services/transaction_service.dart';

class TransactionHistoryController extends GetxController {
  final TransactionService _transactionService = Get.put(TransactionService());

  // Wallet State
  var walletTransactions = <TransactionModel>[].obs;
  var isWalletLoading = false.obs;
  var walletPage = 1;
  var walletHasMore = true;

  // Cash State
  var cashTransactions = <TransactionModel>[].obs;
  var isCashLoading = false.obs;
  var cashPage = 1;
  var cashHasMore = true;

  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    // Fetch both initially or just the first tab? Let's fetch both for smoother UX
    fetchWalletTransactions();
    fetchCashTransactions();
  }

  Future<void> fetchWalletTransactions({bool refresh = false}) async {
    if (isWalletLoading.value) return;

    if (refresh) {
      walletPage = 1;
      walletHasMore = true;
      walletTransactions.clear();
    }

    if (!walletHasMore) return;

    isWalletLoading.value = true;
    try {
      final newTxns = await _transactionService.fetchTransactions(
        type: 'WALLET',
        page: walletPage,
        limit: limit,
      );

      if (newTxns.isEmpty || newTxns.length < limit) {
        walletHasMore = false;
      }

      walletTransactions.addAll(newTxns);
      walletPage++;
    } catch (e) {
      // Error handling
    } finally {
      isWalletLoading.value = false;
    }
  }

  Future<void> fetchCashTransactions({bool refresh = false}) async {
    if (isCashLoading.value) return;

    if (refresh) {
      cashPage = 1;
      cashHasMore = true;
      cashTransactions.clear();
    }

    if (!cashHasMore) return;

    isCashLoading.value = true;
    try {
      final newTxns = await _transactionService.fetchTransactions(
        type: 'CASHONHAND', // Matches screenshot param
        page: cashPage,
        limit: limit,
      );

      if (newTxns.isEmpty || newTxns.length < limit) {
        cashHasMore = false;
      }

      cashTransactions.addAll(newTxns);
      cashPage++;
    } catch (e) {
      // Error handling
    } finally {
      isCashLoading.value = false;
    }
  }
}
