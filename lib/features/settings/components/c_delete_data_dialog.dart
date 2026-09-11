import 'package:flutter/material.dart';
import '../../../core/components/c_app_dialog.dart';
import 'c_delete_data_action_runner.dart';
import 'c_delete_data_content.dart';
import 'c_delete_data_selection.dart';

/// Shows modal dialog with checkboxes allowing the user to choose which trip data to delete.
Future<void> showDeleteAllDataDialog({
  required BuildContext context,
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
  final messenger = ScaffoldMessenger.of(context);
  final selection = DeleteDataSelection();
  bool isSubmitting = false;

  await showAnimatedDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final colorScheme = Theme.of(context).colorScheme;

          return AppDialog(
            icon: Icons.warning_amber_rounded,
            iconColor: colorScheme.error,
            title: 'Delete All Trip Data?',
            actionLabel: selection.allSelected
                ? 'Delete Everything'
                : 'Delete Selected',
            actionColor: colorScheme.error,
            actionForegroundColor: colorScheme.onError,
            isSubmitting: isSubmitting,
            onCancel: () => Navigator.of(dialogContext).pop(false),
            onAction: selection.hasSelection && !isSubmitting
                ? () => DeleteDataActionRunner.run(
                      dialogContext: dialogContext,
                      messenger: messenger,
                      colorScheme: colorScheme,
                      selection: selection,
                      setSubmitting: (v) =>
                          setDialogState(() => isSubmitting = v),
                      onDeleteAllData: onDeleteAllData,
                      onDeleteSelectedData: onDeleteSelectedData,
                      getErrorMessage: getErrorMessage,
                    )
                : null,
            content: DeleteDataContent(
              selection: selection,
              onChanged: () => setDialogState(() {}),
            ),
          );
        },
      );
    },
  );
}
