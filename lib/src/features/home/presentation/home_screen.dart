import 'package:expense_tracker/src/features/home/data/transaction_repository.dart';
import 'package:expense_tracker/src/features/home/presentation/widgets/shimmer_list.dart';
import 'package:expense_tracker/src/features/home/presentation/widgets/transaction_tile.dart';
import 'package:expense_tracker/src/features/home/presentation/widgets/insights_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/src/features/home/domain/transaction_model.dart';
import 'package:expense_tracker/src/features/home/presentation/edit_transaction_controller.dart';
import 'package:expense_tracker/src/routing/app_router.dart';
import 'package:expense_tracker/src/utils/async_ui/error_snackbar_on_async.dart';
import 'package:expense_tracker/src/utils/async_ui/loading_on_async.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(editTransactionControllerProvider, (_, state) {
      state.showSnackbarOnError(context);
      state.showLoading(context);
    });
    final query = ref.watch(transactionsQueryProvider(
        filter: '',
        orderBy: 'dateTime',
        orderSortDescending: true,
        transactionType: 'income,expense'));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            context.goNamed(AppRoute.addTransaction.name);
          }),
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
              onPressed: () {
                context.pushNamed(AppRoute.about.name);
              },
              icon: const Icon(Icons.info)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          const Expanded(flex: 1, child: InsightsWidget()),
          Expanded(
            flex: 2,
            child: FirestoreListView<TransactionModel>(
                padding: const EdgeInsets.only(bottom: 40.0),
                query: query,
                emptyBuilder: (context) => const Center(child: Text('No data')),
                errorBuilder: (context, error, stackTrace) => Center(
                      child: Text(error.toString()),
                    ),
                loadingBuilder: (context) => ShimmerList(),
                itemBuilder: (context, doc) {
                  return TransactionTile(transactionModel: doc.data());
                }),
          ),
        ]),
      ),
    );
  }
}
