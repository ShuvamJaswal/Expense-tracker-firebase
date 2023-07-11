import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueErrorSnackbar on AsyncValue {
  void showSnackbarOnError(BuildContext context) {
    if (!isLoading && hasError) {
      final message = error.toString();
      debugPrint(message);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please check your connection!")));
    }
  }
}
