import 'package:flutter/material.dart';
import '../../../core/components/c_app_snack_bar.dart';
import 'c_delete_data_selection.dart';

/// Handles data deletion mutation and user feedback notifications.
class DeleteDataActionRunner {
  static Future<void> run({
    required BuildContext screenContext,
    required BuildContext dialogContext,
    required DeleteDataSelection selection,
    required void Function(bool) setSubmitting,
    Future<bool> Function()? onDeleteAllData,
    Future<bool> Function({
      bool deleteExpenses,
      bool deleteExchanges,
      bool deleteBorrows,
      bool deleteInitialBalances,
      bool deleteFriends,
    })? onDeleteSelectedData,
    String? Function()? getErrorMessage,
  }) async {
    setSubmitting(true);
    bool success = false;

    try {
      if (onDeleteSelectedData != null) {
        success = await onDeleteSelectedData(
          deleteExpenses: selection.deleteExpenses,
          deleteExchanges: selection.deleteExchanges,
          deleteBorrows: selection.deleteBorrows,
          deleteInitialBalances: selection.deleteInitialBalances,
          deleteFriends: selection.deleteFriends,
        );
      } else if (onDeleteAllData != null) {
        success = await onDeleteAllData();
      }
    } catch (_) {
      success = false;
    }

    if (dialogContext.mounted) {
      Navigator.of(dialogContext).pop(success);
    }

    if (screenContext.mounted) {
      if (success) {
        AppSnackBar.show(
          screenContext,
          message: selection.allSelected
              ? 'All trip data has been deleted.'
              : 'Selected trip data has been deleted.',
          type: AppSnackBarType.success,
        );
      } else {
        final msg = getErrorMessage?.call() ?? 'Failed to delete data';
        AppSnackBar.show(
          screenContext,
          message: msg,
          type: AppSnackBarType.error,
        );
      }
    }
  }
}
