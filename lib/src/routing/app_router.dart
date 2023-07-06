// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:expense_tracker/src/features/about/presentation/about_screen.dart';
import 'package:expense_tracker/src/features/home/domain/transaction_model.dart';
import 'package:expense_tracker/src/features/home/presentation/transactions_screen/transactions_screen.dart';
import 'package:expense_tracker/src/features/home/presentation/transaction_details_screen.dart';
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

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Income',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
              backgroundColor: Colors.blue),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

enum AppRoute {
  income,
  expense,
  onBoarding,
  home,
  addTransaction,
  profile,
  signin,
  editTransaction,
  transactionDetail,
  about,
}

@riverpod
GoRouter goRouter(Ref ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final signInRepository = ref.watch(signinRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  Stream refreshStream = StreamGroup.merge([authRepository.authStateChanges()]);
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(refreshStream),
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/about',
          name: AppRoute.about.name,
          builder: (context, state) => AboutScreen()),
      GoRoute(
        path: '/',
        name: AppRoute.onBoarding.name,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        path: '/signin',
        name: AppRoute.signin.name,
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const Sign(),
        ),
      ),
      GoRoute(
        path: '/edit',
        name: AppRoute.editTransaction.name,
        pageBuilder: (context, state) {
          final transaction = state.extra as TransactionModel?;
          return MaterialPage(
            key: state.pageKey,
            // fullscreenDialog: true,
            child: EditTransactionScreen(transaction: transaction),
          );
        },
      ),
      GoRoute(
        path: '/detail',
        name: AppRoute.transactionDetail.name,
        pageBuilder: (context, state) {
          final transaction = state.extra as TransactionModel;
          return MaterialPage(
            key: state.pageKey,
            // fullscreenDialog: true,
            child: TransactionDetailScreen(transactionModel: transaction),
          );
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
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
                ],
              ),
            ],
          ),
          StatefulShellBranch(routes: [
            GoRoute(
                path: '/transactions',
                name: AppRoute.income.name,
                pageBuilder: (context, state) => const MaterialPage(
                      fullscreenDialog: true,
                      child: TransactionsScreen(),
                    )),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/account',
              name: AppRoute.profile.name,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const CustomProfileScreen(),
              ),
            ),
          ])
        ],
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
