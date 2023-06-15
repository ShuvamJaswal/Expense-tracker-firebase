// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsQueryHash() => r'bcf51a45cf59f58691d2adc29825a777d4245a05';

/// See also [transactionsQuery].
@ProviderFor(transactionsQuery)
final transactionsQueryProvider =
    AutoDisposeProvider<Query<TransactionModel>>.internal(
  transactionsQuery,
  name: r'transactionsQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionsQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TransactionsQueryRef = AutoDisposeProviderRef<Query<TransactionModel>>;
String _$transactionRepositoryHash() =>
    r'd52f234e664cc36fa2d187fc1740937f3a468bbb';

/// See also [transactionRepository].
@ProviderFor(transactionRepository)
final transactionRepositoryProvider =
    AutoDisposeProvider<TransactionRepository>.internal(
  transactionRepository,
  name: r'transactionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$transactionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TransactionRepositoryRef
    = AutoDisposeProviderRef<TransactionRepository>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
