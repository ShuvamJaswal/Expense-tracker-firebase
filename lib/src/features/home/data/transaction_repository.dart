import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:expense_tracker/src/features/home/domain/transaction_model.dart';
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
  Future<void> updateTransaction({
    required TransactionModel transaction,
    required String userId,
  }) {
    final batch = _firestore.batch();
    batch.update(
        _firestore
            .doc(transactionPath(userId, transaction.firestoreId.toString())),
        transaction.toJson());
    return batch.commit().timeout(Duration(seconds: 5));
  }

  Future<void> addTransaction({
    required TransactionModel transactionModel,
    required String userId,
  }) {
    final batch = _firestore.batch();
    batch.set(_firestore.collection(transactionsPath(userId)).doc(),
        transactionModel.toJson());
    return batch.commit().timeout(Duration(seconds: 5));
  }

  Future<void> deleteTransaction(
          {required String uid, required String transactionId}) =>
      _firestore.doc(transactionPath(uid, transactionId)).delete();

  Query<TransactionModel> queryTransactions(
          {required String uid,
          required String orderBy,
          required String filter,
          required bool orderSortDescending,
          required String transactionType}) =>
      _firestore
          .collection(transactionsPath(uid))
          .where('transactionType', whereIn: transactionType.split(','))
          .orderBy(orderBy, descending: orderSortDescending)
          .withConverter(
            fromFirestore: (snapshot, _) =>
                TransactionModel.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (transaction, _) => transaction.toJson(),
          );
}

@riverpod
Query<TransactionModel> transactionsQuery(
  TransactionsQueryRef ref, {
  required String orderBy,
  required String filter,
  required bool orderSortDescending,
  required String transactionType,
}) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.queryTransactions(
      uid: user.uid,
      filter: filter,
      orderBy: orderBy,
      orderSortDescending: orderSortDescending,
      transactionType: transactionType);
}

@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  return TransactionRepository(FirebaseFirestore.instance);
}

@riverpod
Stream<Map<String, num>> insights(InsightsRef ref) async* {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user != null) {
    var docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('transactions');
    num income = 0;
    num expense = 0;

    await for (var snapshot in docRef.snapshots()) {
      income = 0;
      expense = 0;

      for (var element in snapshot.docs) {
        if (element.data()['transactionType'] == 'income') {
          income += num.tryParse(element.data()['amount'].toString()) ?? 0;
        } else {
          expense += num.tryParse(element.data()['amount'].toString()) ?? 0;
        }
      }

      yield {'income': income, 'expense': expense};
    }
  }
}
