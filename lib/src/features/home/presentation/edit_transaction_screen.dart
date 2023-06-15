import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/src/features/home/domain/transaction.dart';
import 'package:expense_tracker/src/features/home/presentation/edit_transaction_controller.dart';

class EditTransactionScreen extends ConsumerStatefulWidget {
  const EditTransactionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  TransactionType tType = TransactionType.income;
  final TextEditingController _amountController = TextEditingController();
  bool switchState = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("ABC"),
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
                                    .addTransaction(
                                      amount: _amountController.text,
                                      dateTime: DateTime.now(),
                                      name: _nameController.text,
                                      transactionType: tType,
                                    );
                                // print(success);
                                if (success && mounted) {
                                  context.pop();
                                }
                              }
                              // Navigator.pop(context);
                            },
                            child: const Text('Add'))
                      ]))),
        )));
  }
}
