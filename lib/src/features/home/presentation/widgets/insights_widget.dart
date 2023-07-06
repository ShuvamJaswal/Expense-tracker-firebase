import 'package:expense_tracker/src/features/home/data/transaction_repository.dart';
import 'package:expense_tracker/src/utils/dialog/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                          style: TextStyle(
                              fontSize: 20,
                              color: (data['income'] ?? 0) +
                                          (data['expense'] ?? 0) <
                                      0
                                  ? Colors.red
                                  : Colors.green),
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
