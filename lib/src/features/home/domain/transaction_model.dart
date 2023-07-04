enum TransactionType { income, expense }

class TransactionModel {
  final String name;
  final String? firestoreId;
  final String? description;
  final DateTime dateTime;
  final TransactionType transactionType;
  final num amount;
  String nameLower = '';
  TransactionModel(
      {required this.name,
      required this.dateTime,
      required this.transactionType,
      required this.amount,
      this.firestoreId,
      this.description}) {
    nameLower = name.toLowerCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'transactionType': transactionType.toString().split('.')[1],
      'amount': amount,
      'description': description,
      'nameLower': nameLower,
    };
  }

  factory TransactionModel.fromJson(
      Map<String, dynamic> data, String firestoreId) {
    return TransactionModel(
      name: data['name'],
      firestoreId: firestoreId,
      amount: num.parse(data['amount'].toString()),
      dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
      transactionType: TransactionType.values.byName(
        data['transactionType'],
      ),
      description: data['description'],
    );
  }
}
