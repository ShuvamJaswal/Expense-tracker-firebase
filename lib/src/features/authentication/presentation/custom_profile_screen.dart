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
    return ProfileScreen(
      providers: providers,
      children: [
        ElevatedButton(
          onPressed: () {
            context.pop();
          },
          child: Container(child: Text('Go back')),
        ),
      ],
    );
  }
}
