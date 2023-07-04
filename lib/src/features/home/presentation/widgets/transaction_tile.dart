import 'package:expense_tracker/src/features/home/domain/transaction_model.dart';
import 'package:expense_tracker/src/features/home/presentation/transaction_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//TODO:Add negative sign in amount on firestore itself to help with sorting.
class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transactionModel});
  final TransactionModel transactionModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          useRootNavigator: true,
          enableDrag: true,
          context: context,
          builder: (context) =>
              TransactionDetailScreen(transactionModel: transactionModel),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Material(
                color: Colors.transparent,
                child: Text("Name: ${transactionModel.name}")),
            subtitle: Material(
              color: Colors.transparent,
              child: Text(
                  "Type: ${transactionModel.transactionType == TransactionType.income ? "Income" : "Expense"}"),
            ),
            trailing: Material(
              color: Colors.transparent,
              child: Text(
                (transactionModel.transactionType == TransactionType.income
                        ? "+"
                        : "-") +
                    transactionModel.amount.toString(),
                style: TextStyle(
                    fontSize: 20,
                    color: transactionModel.transactionType ==
                            TransactionType.income
                        ? Colors.green
                        : Colors.red),
              ),
            ),
            leading: Material(
              color: Colors.transparent,
              child:
                  Text(DateFormat('E \ndd').format(transactionModel.dateTime)),
            ),
          ),
        ),
      ),
    );
  }
}
