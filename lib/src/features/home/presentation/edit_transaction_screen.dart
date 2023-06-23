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
  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      TransactionModel transactionModel = TransactionModel(
          name: _nameController.text,
          dateTime: DateTime.now(),
          transactionType: tType,
          amount: _amountController.text,
          firestoreId: firestoreid);
      final success = await ref
          .read(editTransactionControllerProvider.notifier)
          .submit(transactionModel: transactionModel);
      if (success && mounted) {
        context.pop(transactionModel);
      }
    }
  }

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
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              onSaved: (value) =>
                                  _nameController.text = value!.trim(),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().isEmpty) {
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
                              onSaved: (value) =>
                                  _amountController.text = value!.trim(),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: false,
                                decimal: false,
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a numeric value.';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Please enter a numeric value.';
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
                              onPressed: _submit,
                              child: Text(widget.transaction == null
                                  ? "Add"
                                  : "Update"))
                        ]))),
          ),
        )));
  }
}
