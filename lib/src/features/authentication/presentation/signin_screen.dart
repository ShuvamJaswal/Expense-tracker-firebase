import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/src/features/authentication/data/firebase_auth_repository.dart';
import 'package:expense_tracker/src/features/authentication/presentation/signin_controller.dart';

import 'package:expense_tracker/src/utils/async_ui/error_snackbar_on_async.dart';
import 'package:expense_tracker/src/utils/async_ui/loading_on_async.dart';

class Sign extends ConsumerWidget {
  const Sign({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(signinControllerProvider, (_, state) {
      state.showSnackbarOnError(context);
      state.showLoading(context);
    });
    final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
    final authproviders = ref.watch(authProvidersProvider);

    return Theme(
      data: ThemeData.dark(useMaterial3: true).copyWith(
        visualDensity: VisualDensity.standard,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
        textButtonTheme: TextButtonThemeData(style: buttonStyle),
        outlinedButtonTheme: OutlinedButtonThemeData(style: buttonStyle),
      ),
      child: SignInScreen(
          actions: [
            AuthStateChangeAction<UserCreated>((context, state) async {
              await ref
                  .watch(signinControllerProvider.notifier)
                  .completeRegistration();
            }),
          ],
          subtitleBuilder: (context, action) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                action == AuthAction.signIn
                    ? 'Welcome to Expense Tracker! Please sign in to continue.'
                    : 'Welcome to Expense Tracker! Please create an account to continue',
              ),
            );
          },
          footerBuilder: (context, action) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40), // NEW
                    ),
                    onPressed: () async {
                      await ref
                          .watch(signinControllerProvider.notifier)
                          .completeAnonSignin();
                    },
                    child: const Text('Continue Without account')),
              ),
            );
          },
          providers: authproviders,
          styles: const {
            EmailFormStyle(
              signInButtonVariant: ButtonVariant.filled,
            )
          }),
    );
  }
}
