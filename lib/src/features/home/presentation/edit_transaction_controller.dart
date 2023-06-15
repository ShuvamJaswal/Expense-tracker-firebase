import 'package:expense_tracker/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:expense_tracker/src/features/home/data/transaction_repository.dart';
import 'package:expense_tracker/src/features/home/domain/transaction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'edit_transaction_controller.g.dart';

@riverpod
class EditTransactionController extends _$EditTransactionController {
  @override
  FutureOr<void> build() {}
  Future<bool> addTransaction({
    required String name,
    required DateTime dateTime,
    required TransactionType transactionType,
    required String amount,
  }) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    final transactionRepository = ref.read(transactionRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await transactionRepository.addTransaction(
          amount: amount,
          dateTime: dateTime,
          name: name,
          transactionType: transactionType,
          userId: currentUser.uid);
    });
    return !state.hasError;
  }
}
