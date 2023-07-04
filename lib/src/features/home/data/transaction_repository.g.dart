// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionsQueryHash() => r'd31959f179a2066dadc91f9566dead3b9e4b9d0e';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef TransactionsQueryRef = AutoDisposeProviderRef<Query<TransactionModel>>;

/// See also [transactionsQuery].
@ProviderFor(transactionsQuery)
const transactionsQueryProvider = TransactionsQueryFamily();

/// See also [transactionsQuery].
class TransactionsQueryFamily extends Family<Query<TransactionModel>> {
  /// See also [transactionsQuery].
  const TransactionsQueryFamily();

  /// See also [transactionsQuery].
  TransactionsQueryProvider call({
    required String orderBy,
    required String filter,
    required bool orderSortDescending,
    required String transactionType,
  }) {
    return TransactionsQueryProvider(
      orderBy: orderBy,
      filter: filter,
      orderSortDescending: orderSortDescending,
      transactionType: transactionType,
    );
  }

  @override
  TransactionsQueryProvider getProviderOverride(
    covariant TransactionsQueryProvider provider,
  ) {
    return call(
      orderBy: provider.orderBy,
      filter: provider.filter,
      orderSortDescending: provider.orderSortDescending,
      transactionType: provider.transactionType,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'transactionsQueryProvider';
}

/// See also [transactionsQuery].
class TransactionsQueryProvider
    extends AutoDisposeProvider<Query<TransactionModel>> {
  /// See also [transactionsQuery].
  TransactionsQueryProvider({
    required this.orderBy,
    required this.filter,
    required this.orderSortDescending,
    required this.transactionType,
  }) : super.internal(
          (ref) => transactionsQuery(
            ref,
            orderBy: orderBy,
            filter: filter,
            orderSortDescending: orderSortDescending,
            transactionType: transactionType,
          ),
          from: transactionsQueryProvider,
          name: r'transactionsQueryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$transactionsQueryHash,
          dependencies: TransactionsQueryFamily._dependencies,
          allTransitiveDependencies:
              TransactionsQueryFamily._allTransitiveDependencies,
        );

  final String orderBy;
  final String filter;
  final bool orderSortDescending;
  final String transactionType;

  @override
  bool operator ==(Object other) {
    return other is TransactionsQueryProvider &&
        other.orderBy == orderBy &&
        other.filter == filter &&
        other.orderSortDescending == orderSortDescending &&
        other.transactionType == transactionType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderBy.hashCode);
    hash = _SystemHash.combine(hash, filter.hashCode);
    hash = _SystemHash.combine(hash, orderSortDescending.hashCode);
    hash = _SystemHash.combine(hash, transactionType.hashCode);

    return _SystemHash.finish(hash);
  }
}

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
String _$insightsHash() => r'f9f587e3b106128884fa85d3eacf5aac325e4006';

/// See also [insights].
@ProviderFor(insights)
final insightsProvider = AutoDisposeStreamProvider<Map<String, num>>.internal(
  insights,
  name: r'insightsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$insightsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef InsightsRef = AutoDisposeStreamProviderRef<Map<String, num>>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
