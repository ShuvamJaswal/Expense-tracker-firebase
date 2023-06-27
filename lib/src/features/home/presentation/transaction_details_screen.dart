import 'package:expense_tracker/src/features/home/domain/transaction.dart';
import 'package:expense_tracker/src/features/home/presentation/edit_transaction_controller.dart';
import 'package:expense_tracker/src/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class TransactionDetailScreen extends ConsumerStatefulWidget {
  const TransactionDetailScreen({super.key, required this.transactionModel});
  final TransactionModel transactionModel;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState
    extends ConsumerState<TransactionDetailScreen> {
  late TransactionModel transactionModel;

  @override
  void initState() {
    super.initState();
    transactionModel = widget.transactionModel;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  bool success = await ref
                      .read(editTransactionControllerProvider.notifier)
                      .deleteEntry(transactionModel.firestoreId.toString());
                  if (success && mounted) {
                    context.pop();
                  }
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      transactionModel.amount,
                      style: const TextStyle(fontSize: 50),
                    ),
                  ),
                  Center(
                    child: Text(
                      transactionModel.name,
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 4, 16.0, 20),
                    child: Text(
                      'Date ${DateFormat('dd/mm/yy HH:MM').format(transactionModel.dateTime)}',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10)),
                          onPressed: () async {
                            TransactionModel? val = await context.pushNamed(
                                AppRoute.editTransaction.name,
                                extra: transactionModel);
                            if (val != null) {
                              setState(() {
                                transactionModel = val;
                              });
                            }
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit")),
                      TextButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[800],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10)),
                          onPressed: () {
                            showDialog(
                              barrierColor: Colors.black,
                              context: context,
                              builder: (context) => const Center(
                                  child: Text('No implementation yet')),
                            );
                          },
                          icon: const Icon(Icons.horizontal_split_outlined),
                          label: const Text("Split")),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              )),
        ),
      ),
    );
  }
}