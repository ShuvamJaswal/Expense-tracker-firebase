import 'package:expense_tracker/src/features/home/presentation/transaction_details_screen.dart';
import 'package:expense_tracker/src/utils/dialog/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:expense_tracker/src/features/home/data/transaction_repository.dart';
import 'package:expense_tracker/src/features/home/domain/transaction.dart';
import 'package:expense_tracker/src/features/home/presentation/edit_transaction_controller.dart';
import 'package:expense_tracker/src/routing/app_router.dart';
import 'package:expense_tracker/src/utils/async_ui/error_snackbar_on_async.dart';
import 'package:expense_tracker/src/utils/async_ui/loading_on_async.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(editTransactionControllerProvider, (_, state) {
      state.showSnackbarOnError(context);
      state.showLoading(context);
    });
    final query = ref.watch(transactionsQueryProvider);
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
                ref.read(authRepositoryProvider).signOut();
              },
              icon: const Icon(Icons.logout)),
          IconButton(
              onPressed: () {
                GoRouter.of(context).pushNamed(AppRoute.profile.name);
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          const Expanded(flex: 1, child: InsightsWidget()),
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

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transactionModel});
  final TransactionModel transactionModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
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

class InsightsWidget extends ConsumerWidget {
  const InsightsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(insightsProvider);
    return insights.when(
      data: (data) {
        return Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('INCOME'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "+${(data['income'] ?? 0).toString()}",
                        style:
                            const TextStyle(color: Colors.green, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.black,
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('TOTAL'),
                        Text(
                          ((data['income'] ?? 0) + (data['expense'] ?? 0))
                              .toString(),
                          style: const TextStyle(fontSize: 20),
                        )
                      ],
                    )),
              ),
              Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('EXPENSE'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        (data['expense'] ?? 0).toString(),
                        style: const TextStyle(color: Colors.red, fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => const Text('Wrong'),
      loading: () => const LoadingDialog(),
    );
  }
}
