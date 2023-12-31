import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/src/routing/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      theme: ThemeData.dark(useMaterial3: true),
      // theme: ThemeData.dark().copyWith(useMaterial3: true),
      routerConfig: goRouter,
    );
  }
}
