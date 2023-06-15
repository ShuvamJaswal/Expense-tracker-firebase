// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_auth_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseAuthHash() => r'46c40b7c5cf8ab936c0daa96a6af106bd2ae5d51';

/// See also [firebaseAuth].
@ProviderFor(firebaseAuth)
final firebaseAuthProvider = Provider<FirebaseAuth>.internal(
  firebaseAuth,
  name: r'firebaseAuthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$firebaseAuthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FirebaseAuthRef = ProviderRef<FirebaseAuth>;
String _$authRepositoryHash() => r'3871275ded2762a0e529629be71e890bfd3bd7ad';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$authStateChangesHash() => r'af0a0185c59bf3c1ad8a9e041075517b3a2dcc31';

/// See also [authStateChanges].
@ProviderFor(authStateChanges)
final authStateChangesProvider = AutoDisposeStreamProvider<User?>.internal(
  authStateChanges,
  name: r'authStateChangesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authStateChangesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthStateChangesRef = AutoDisposeStreamProviderRef<User?>;
String _$authProvidersHash() => r'ae6cefe8190c6d4e0c24eed661e7889031bfabda';

/// See also [authProviders].
@ProviderFor(authProviders)
final authProvidersProvider =
    Provider<List<AuthProvider<AuthListener, AuthCredential>>>.internal(
  authProviders,
  name: r'authProvidersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authProvidersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthProvidersRef
    = ProviderRef<List<AuthProvider<AuthListener, AuthCredential>>>;
String _$signinRepositoryHash() => r'aa7cadc53b3cadffed864b230777fc4dcf1f6c25';

/// See also [signinRepository].
@ProviderFor(signinRepository)
final signinRepositoryProvider = Provider<SigninRepository>.internal(
  signinRepository,
  name: r'signinRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signinRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SigninRepositoryRef = ProviderRef<SigninRepository>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions