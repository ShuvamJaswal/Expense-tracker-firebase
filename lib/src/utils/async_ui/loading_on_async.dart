import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/src/utils/dialog/check_if_a_dialog_is_showing.dart';
import 'package:expense_tracker/src/utils/dialog/loading_dialog.dart';

extension AsyncValueErrorSnackbar on AsyncValue {
  void showLoading(BuildContext context) {
    if (isLoading) {
      showDialog(
        barrierDismissible: false,
        useSafeArea: true,
        context: context,
        builder: (context) => const LoadingDialog(),
      );
    }
    if (!(isLoading) && checkIfADialogIsShowing(context)) {
      Navigator.of(context).pop();
    }
  }
}
