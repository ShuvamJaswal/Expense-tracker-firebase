import 'package:expense_tracker/src/features/home/domain/transaction_model.dart';
import 'package:expense_tracker/src/features/home/presentation/edit_transaction_controller.dart';
import 'package:expense_tracker/src/features/home/presentation/query_transactions_controller.dart';
import 'package:expense_tracker/src/features/home/presentation/widgets/transaction_tile.dart';
import 'package:expense_tracker/src/utils/async_ui/error_snackbar_on_async.dart';
import 'package:expense_tracker/src/utils/async_ui/loading_on_async.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SortBuilder extends ConsumerStatefulWidget {
  const SortBuilder({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SortBuilderState();
}

class _SortBuilderState extends ConsumerState<SortBuilder> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        underline: Container(),
        icon: const Icon(Icons.sort, color: Colors.white),
        items: [
          DropdownMenuItem<String>(
            value: 'nameLower',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('Name'),
                if (ref
                        .watch(queryTransactionsControllerProvider.notifier)
                        .currentSorting ==
                    'nameLower')
                  Icon(
                    ref
                                .watch(queryTransactionsControllerProvider
                                    .notifier)
                                .currentOrder ==
                            false
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: Colors.white,
                  )
              ],
            ),
          ),
          DropdownMenuItem<String>(
            value: 'dateTime',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('Date'),
                if (ref
                        .watch(queryTransactionsControllerProvider.notifier)
                        .currentSorting ==
                    'dateTime')
                  Icon(
                    ref
                                .watch(queryTransactionsControllerProvider
                                    .notifier)
                                .currentOrder ==
                            false
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: Colors.white,
                  )
              ],
            ),
          ),
          DropdownMenuItem<String>(
            value: 'amount',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('Amount'),
                if (ref
                        .watch(queryTransactionsControllerProvider.notifier)
                        .currentSorting ==
                    'amount')
                  Icon(
                    ref
                                .watch(queryTransactionsControllerProvider
                                    .notifier)
                                .currentOrder ==
                            false
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    color: Colors.white,
                  )
              ],
            ),
          ),
        ],
        onChanged: (value) {
          if (ref
                  .read(queryTransactionsControllerProvider.notifier)
                  .currentSorting ==
              value) {
            ref
                .watch(queryTransactionsControllerProvider.notifier)
                .toggleSorting();
          } else {
            ref
                .read(queryTransactionsControllerProvider.notifier)
                .getQuery(filter: value);
          }
          ref
              .read(queryTransactionsControllerProvider.notifier)
              .getQuery(orderBy: value);
        });
  }
}

class FilterChoiceWidget extends ConsumerStatefulWidget {
  const FilterChoiceWidget({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterChoiceWidgetState();
}

class _FilterChoiceWidgetState extends ConsumerState<FilterChoiceWidget> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 5),
          child: ChoiceChip(
            label: const Text('All'),
            labelStyle: const TextStyle(color: Colors.white),
            backgroundColor: Colors.black,
            selected: _selectedIndex == 0,
            selectedColor: Colors.red,
            onSelected: (bool value) {
              setState(() {
                _selectedIndex = 0;
                ref
                    .read(queryTransactionsControllerProvider.notifier)
                    .getQuery(transactionType: 'income,expense');
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 5),
          child: ChoiceChip(
            label: const Text("Income"),
            labelStyle: const TextStyle(color: Colors.white),
            backgroundColor: Colors.black,
            selected: _selectedIndex == 1,
            selectedColor: Colors.red,
            onSelected: (bool value) {
              setState(() {
                _selectedIndex = 1;
                ref
                    .read(queryTransactionsControllerProvider.notifier)
                    .getQuery(transactionType: 'income');
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 5),
          child: ChoiceChip(
            label: const Text('Expense'),
            labelStyle: const TextStyle(color: Colors.white),
            backgroundColor: Colors.black,
            selected: _selectedIndex == 2,
            selectedColor: Colors.red,
            onSelected: (bool value) {
              setState(
                () {
                  _selectedIndex = 2;
                  ref
                      .read(queryTransactionsControllerProvider.notifier)
                      .getQuery(transactionType: 'expense');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(editTransactionControllerProvider, (_, state) {
      state.showSnackbarOnError(context);
      state.showLoading(context);
    });
    final query = ref.watch(queryTransactionsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          // ignore: prefer_const_constructors If using const arrow direction and position is not changing for sorting, prefer_const_constructors
          SortBuilder(),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          const FilterChoiceWidget(),
          Expanded(
            flex: 2,
            child: FirestoreListView<TransactionModel>(
                query: query,
                emptyBuilder: (context) => const Center(child: Text('No data')),
                errorBuilder: (context, error, stackTrace) => Center(
                      child: Text(error.toString()),
                    ),
                loadingBuilder: (context) => const Center(
                      child: SpinKitThreeBounce(
                        color: Colors.blueAccent,
                        size: 50.0,
                      ),
                    ),
                itemBuilder: (context, doc) {
                  return TransactionTile(transactionModel: doc.data());
                }),
          ),
        ]),
      ),
    );
  }
}
