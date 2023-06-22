import 'package:expense_tracker/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:expense_tracker/src/features/home/data/transaction_repository.dart';
import 'package:expense_tracker/src/features/home/domain/transaction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'edit_transaction_controller.g.dart';

@riverpod
class EditTransactionController extends _$EditTransactionController {
  @override
  FutureOr<void> build() {}
  Future<bool> deleteEntry(String transactionId) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    final repository = ref.read(transactionRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repository.deleteTransaction(
        uid: currentUser.uid.toString(), transactionId: transactionId));
    return !state.hasError;
  }

  Future<bool> submit({required TransactionModel transactionModel}) async {
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) {
      throw AssertionError('User can\'t be null');
    }
    final transactionRepository = ref.read(transactionRepositoryProvider);
    state = const AsyncLoading();
    if (transactionModel.firestoreId == null) {
      state = await AsyncValue.guard(() async {
        await transactionRepository.addTransaction(
            transaction: transactionModel, userId: currentUser.uid);
      });
    } else {
      state = await AsyncValue.guard(() async {
        await transactionRepository.updateTransaction(
            transaction: transactionModel, userId: currentUser.uid);
      });
    }

    return !state.hasError;
  }
}
