import 'package:flutter/material.dart';
import 'c_delete_data_selection.dart';

/// Handles data deletion mutation and user feedback notifications.
class DeleteDataActionRunner {
  static Future<void> run({
    required BuildContext dialogContext,
    required ScaffoldMessengerState messenger,
    required ColorScheme colorScheme,
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

    if (success) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            selection.allSelected
                ? 'All trip data has been deleted.'
                : 'Selected trip data has been deleted.',
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      final msg = getErrorMessage?.call() ?? 'Failed to delete data';
      messenger.showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }
}
