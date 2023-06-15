import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:expense_tracker/src/routing/app_router.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker.'),
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              context.goNamed(AppRoute.signin.name);
            },
            child: const Text('Get Started')),
      ),
    );
  }
}
