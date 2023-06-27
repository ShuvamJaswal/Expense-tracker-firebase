import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/src/features/authentication/data/firebase_auth_repository.dart';

class CustomProfileScreen extends ConsumerWidget {
  const CustomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providers = ref.watch(authProvidersProvider);
    return Theme(
      data: ThemeData.light(
        useMaterial3: true,
      ),
      child: ProfileScreen(
        providers: providers,
        children: [
          OutlinedButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Go back'),
          ),
        ],
      ),
    );
  }
}
