import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nammastore_rider/controller/transaction_history_controller.dart';
import 'package:nammastore_rider/models/transaction_model.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransactionHistoryController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text(
            "Transaction History",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: const TabBar(
            labelColor: Color(0xFFFF5252),
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFFFF5252),
            tabs: [
              Tab(text: "My Wallet"),
              Tab(text: "Cash on Hand"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Wallet Tab
            Obx(
              () => _buildTransactionList(
                transactions: controller.walletTransactions,
                isLoading: controller.isWalletLoading.value,
                hasMore: controller.walletHasMore,
                onRefresh: () =>
                    controller.fetchWalletTransactions(refresh: true),
                onLoadMore: () => controller.fetchWalletTransactions(),
              ),
            ),

            // Cash Tab
            Obx(
              () => _buildTransactionList(
                transactions: controller.cashTransactions,
                isLoading: controller.isCashLoading.value,
                hasMore: controller.cashHasMore,
                onRefresh: () =>
                    controller.fetchCashTransactions(refresh: true),
                onLoadMore: () => controller.fetchCashTransactions(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList({
    required List<TransactionModel> transactions,
    required bool isLoading,
    required bool hasMore,
    required Future<void> Function() onRefresh,
    required VoidCallback onLoadMore,
  }) {
    if (isLoading && transactions.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (transactions.isEmpty) {
      return const Center(child: Text("No transactions found."));
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: transactions.length + 1,
        itemBuilder: (context, index) {
          if (index == transactions.length) {
            return hasMore
                ? Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: ElevatedButton(
                        onPressed: onLoadMore,
                        child: isLoading
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
                : const SizedBox(height: 50);
          }

          final txn = transactions[index];
          return _buildTransactionCard(txn);
        },
      ),
    );
  }

  Widget _buildTransactionCard(TransactionModel txn) {
    final date = txn.createdAt != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(txn.createdAt!)
        : "Unknown Date";

    final isCredit = txn.entryType == "CREDIT";
    final color = isCredit ? Colors.green : Colors.red;
    final prefix = isCredit ? "+" : "-";

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.type ?? "Transaction",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                if (txn.orderId != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    "Order: #${txn.orderId}",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "$prefix₹${txn.amount}",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  txn.status ?? "UNKNOWN",
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
