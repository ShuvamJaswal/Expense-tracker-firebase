import 'package:expense_tracker/src/features/home/data/transaction_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'query_transactions_controller.g.dart';

@riverpod
class QueryTransactionsController extends _$QueryTransactionsController {
  var stateP = MyState();
  QueryTransactionsController() {
    stateP = stateP.copyWith();
  }
  String get currentSorting => stateP.orderBy;
  bool get currentOrder => stateP.orderSortDescending;
  @override
  build() {
    return ref.watch(transactionsQueryProvider(
      filter: stateP.filter,
      orderSortDescending: stateP.orderSortDescending,
      orderBy: stateP.orderBy,
      transactionType: stateP.transactionType,
    ));
  }

  void getQuery(
      {String? filter,
      bool? orderSortDescending,
      String? orderBy,
      String? transactionType}) {
    stateP = stateP.copyWith(
      orderSortDescending: orderSortDescending ?? stateP.orderSortDescending,
      filter: filter ?? stateP.filter,
      orderBy: orderBy ?? stateP.orderBy,
      transactionType: transactionType ?? stateP.transactionType,
    );
    state = ref.watch(transactionsQueryProvider(
        filter: stateP.filter,
        orderSortDescending: stateP.orderSortDescending,
        orderBy: stateP.orderBy,
        transactionType: stateP.transactionType));
  }

  void toggleSorting() {
    stateP = stateP.copyWith(orderSortDescending: !stateP.orderSortDescending);
    state = ref.watch(transactionsQueryProvider(
        filter: stateP.filter,
        orderSortDescending: stateP.orderSortDescending,
        orderBy: stateP.orderBy,
        transactionType: stateP.transactionType));
  }
}

class MyState {
  String orderBy;
  String filter;
  bool orderSortDescending;
  String transactionType = 'income,expense';
  MyState(
      {this.orderBy = 'dateTime',
      this.filter = '',
      this.orderSortDescending = true,
      this.transactionType = 'income,expense'});

  MyState copyWith(
      {String? orderBy,
      String? filter,
      bool? orderSortDescending,
      String? transactionType}) {
    return MyState(
        orderSortDescending: orderSortDescending ?? this.orderSortDescending,
        transactionType: transactionType ?? this.transactionType,
        orderBy: orderBy ?? this.orderBy,
        filter: filter ?? this.filter);
  }
}
