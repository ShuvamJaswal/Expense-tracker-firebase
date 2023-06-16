enum TransactionType { income, expense }

class TransactionModel {
  final String name;
  final String? firestoreId;
  final DateTime dateTime;
  final TransactionType transactionType;
  final String amount;
  TransactionModel({
    required this.name,
    required this.dateTime,
    required this.transactionType,
    required this.amount,
    this.firestoreId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'transactionType': transactionType.toString().split('.')[1],
      'amount': amount,
    };
  }

  factory TransactionModel.fromJson(
      Map<String, dynamic> data, String firestoreId) {
    return TransactionModel(
        name: data['name'],
        firestoreId: firestoreId,
        amount: data['amount'],
        dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
        transactionType:
            TransactionType.values.byName(data['transactionType']));
  }
}
