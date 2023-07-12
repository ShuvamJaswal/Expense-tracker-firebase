import 'package:expense_tracker/src/features/home/domain/transaction_model.dart';
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
  Future<void> _delete() async {
    await ref
        .read(editTransactionControllerProvider.notifier)
        .deleteEntry(transactionModel.firestoreId.toString());
    // if (success && mounted) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    }
    if (Navigator.of(context).canPop()) {
      context.pop();
    }
    if (Navigator.of(context).canPop()) {
      context.pop();
    }
  } // }

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
            IconButton(onPressed: _delete, icon: const Icon(Icons.delete))
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
                    transactionModel.amount.abs().toString(),
                    style: TextStyle(
                        fontSize: 50,
                        color: transactionModel.amount < 0
                            ? Colors.red
                            : Colors.green),
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
                transactionModel.description == null
                    ? const SizedBox(
                        height: 50,
                      )
                    : SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: SingleChildScrollView(
                              child: Text(transactionModel.description ?? '')),
                        ),
                      ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4, 16.0, 20),
                  child: Text(
                    'Date ${DateFormat("dd/MM/yy 'at' HH:mm").format(transactionModel.dateTime)}',
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
                          context.pop();
                          TransactionModel? val = await context.pushNamed(
                              AppRoute.editTransaction.name,
                              extra: transactionModel);
                          if (val != null && context.mounted) {
                            setState(() {
                              transactionModel = val;
                            });
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit")),
                    //TODO:
                    // TextButton.icon(
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.grey[800],
                    //         padding: const EdgeInsets.symmetric(
                    //             horizontal: 30, vertical: 10)),
                    //     onPressed: () {
                    //       showDialog(
                    //         barrierColor: Colors.black,
                    //         context: context,
                    //         builder: (context) => const Center(
                    //             child: Text('No implementation yet')),
                    //       );
                    //     },
                    //     icon: const Icon(Icons.horizontal_split_outlined),
                    //     label: const Text("Split")),
                  ],
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
