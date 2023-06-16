// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:expense_tracker/src/features/home/domain/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/src/features/authentication/presentation/custom_profile_screen.dart';
import 'package:expense_tracker/src/features/authentication/presentation/signin_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:expense_tracker/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:expense_tracker/src/features/home/presentation/edit_transaction_screen.dart';
import 'package:expense_tracker/src/features/home/presentation/home_screen.dart';
import 'package:expense_tracker/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:expense_tracker/src/routing/go_router_refresh_stream.dart';

part 'app_router.g.dart';

enum AppRoute {
  onBoarding,
  home,
  addTransaction,
  profile,
  signin,
  editTransaction
}

@riverpod
GoRouter goRouter(Ref ref) {
  final signInRepository = ref.watch(signinRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  Stream refreshStream = StreamGroup.merge([authRepository.authStateChanges()]);
  return GoRouter(
    refreshListenable: GoRouterRefreshStream(refreshStream),
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.onBoarding.name,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'transactions/add',
            name: AppRoute.addTransaction.name,
            pageBuilder: (context, state) {
              return MaterialPage(
                fullscreenDialog: true,
                child: EditTransactionScreen(),
              );
            },
          ),
          GoRoute(
            path: 'edit',
            name: AppRoute.editTransaction.name,
            pageBuilder: (context, state) {
              final transaction = state.extra as TransactionModel?;
              return MaterialPage(
                key: state.pageKey,
                fullscreenDialog: true,
                child: EditTransactionScreen(transaction: transaction),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/account',
        name: AppRoute.profile.name,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const CustomProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/signin',
        name: AppRoute.signin.name,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const Sign(),
        ),
      ),
    ],
    redirect: (context, state) {
      final isSigninComplete = signInRepository.isSignincomplete();
      if (!isSigninComplete) {
        if (state.location != '/' && state.location != '/signin') {
          return state.namedLocation(AppRoute.onBoarding.name);
          // return '/';
        }
      } else if (state.location == '/' || state.location == '/signin') {
        return state.namedLocation(AppRoute.home.name);
      }
      return null;
    },
  );
}
