import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueErrorSnackbar on AsyncValue {
  void showSnackbarOnError(BuildContext context) {
    if (!isLoading && hasError) {
      debugPrint(error.toString());
      final message = error.toString();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
