import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/src/features/home/domain/transaction.dart';
import 'package:expense_tracker/src/features/home/presentation/edit_transaction_controller.dart';

// ignore: must_be_immutable
class EditTransactionScreen extends ConsumerStatefulWidget {
  EditTransactionScreen({super.key, this.transaction});
  TransactionModel? transaction;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      firestoreid = widget.transaction!.firestoreId;
      _nameController.text = widget.transaction!.name;
      _amountController.text = widget.transaction!.amount;

      switchState = TransactionType.values.byName(
              widget.transaction!.transactionType.toString().split('.')[1]) ==
          TransactionType.expense;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  TransactionType tType = TransactionType.income;
  final TextEditingController _amountController = TextEditingController();
  bool switchState = false;
  String? firestoreid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.transaction == null ? "Add" : "Edit"),
        ),
        body: SingleChildScrollView(
            child: Card(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: _nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              labelText: "Name",
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            controller: _amountController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              labelText: "Amount",
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Income'),
                            StatefulBuilder(
                              builder: (context, setState) => Switch(
                                value: switchState,
                                onChanged: (value) {
                                  if (value) {
                                    tType = TransactionType.expense;
                                  } else {
                                    tType = TransactionType.income;
                                  }
                                  setState(() {
                                    switchState = value;
                                  });
                                },
                              ),
                            ),
                            const Text('Expense'),
                          ],
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final bool success = await ref
                                    .read(editTransactionControllerProvider
                                        .notifier)
                                    .submit(
                                        transactionModel: TransactionModel(
                                            name: _nameController.text,
                                            dateTime: DateTime.now(),
                                            transactionType: tType,
                                            amount: _amountController.text,
                                            firestoreId: firestoreid));
                                if (success && mounted) {
                                  context.pop();
                                }
                              }
                            },
                            child: Text(
                                widget.transaction == null ? "Add" : "Update"))
                      ]))),
        )));
  }
}
