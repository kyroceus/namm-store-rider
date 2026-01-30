class TransactionModel {
  final String? id;
  final String? riderId;
  final String? orderId;
  final String? amount;
  final String? type; // CASHONHAND, WALLET
  final String? status; // COMPLETED
  final String? entryType; // CREDIT, DEBIT
  final DateTime? createdAt;

  TransactionModel({
    this.id,
    this.riderId,
    this.orderId,
    this.amount,
    this.type,
    this.status,
    this.entryType,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      riderId: json['riderId'],
      orderId: json['orderId'],
      amount: json['amount'],
      type: json['type'],
      status: json['status'],
      entryType: json['entryType'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}
