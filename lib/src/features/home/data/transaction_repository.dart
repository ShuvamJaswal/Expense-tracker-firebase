import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:expense_tracker/src/features/home/domain/transaction.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'transaction_repository.g.dart';

class TransactionRepository {
  const TransactionRepository(
    this._firestore,
  );
  final FirebaseFirestore _firestore;
  static String transactionPath(String uid, String tranactionId) =>
      'users/$uid/transactions/$tranactionId';
  static String transactionsPath(String uid) => 'users/$uid/transactions';
  Future<void> addTransaction({
    required String userId,
    required String name,
    required DateTime dateTime,
    required TransactionType transactionType,
    required String amount,
  }) =>
      _firestore.collection(transactionsPath(userId)).add(
        {
          'name': name,
          'dateTime': dateTime.millisecondsSinceEpoch,
          'transactionType': transactionType.toString().split('.')[1],
          'amount': amount,
        },
      );

  Query<TransactionModel> queryTransactions({required String uid}) =>
      _firestore.collection(transactionsPath(uid)).withConverter(
            fromFirestore: (snapshot, _) =>
                TransactionModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (transaction, _) => transaction.toJson(),
          );
}

@riverpod
Query<TransactionModel> transactionsQuery(TransactionsQueryRef ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.queryTransactions(uid: user.uid);
}

@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  return TransactionRepository(FirebaseFirestore.instance);
}
