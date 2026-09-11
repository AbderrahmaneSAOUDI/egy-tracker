import 'dart:async';
import 'package:flutter/material.dart';
import 'c_app_dialog.dart';
import 'c_confirmation_dialog.dart';

/// Helper function to display a styled confirmation popup with animated entrance,
/// automatic submission state handling, and a consistent UX across the app.
Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  String? subtitle,
  String? message,
  Widget? additionalContent,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  IconData icon = Icons.warning_amber_rounded,
  Color? iconColor,
  Color? confirmColor,
  Color? confirmForegroundColor,
  Color? borderColor,
  bool isDestructive = true,
  FutureOr<bool?> Function()? onConfirm,
}) {
  bool isSubmitting = false;

  return showAnimatedDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return ConfirmationDialog(
            title: title,
            subtitle: subtitle,
            message: message,
            additionalContent: additionalContent,
            confirmLabel: confirmLabel,
            cancelLabel: cancelLabel,
            icon: icon,
            iconColor: iconColor,
            confirmColor: confirmColor,
            confirmForegroundColor: confirmForegroundColor,
            borderColor: borderColor,
            isDestructive: isDestructive,
            isSubmitting: isSubmitting,
            onCancel: () => Navigator.of(dialogContext).pop(false),
            onConfirm: () async {
              if (onConfirm != null) {
                setDialogState(() => isSubmitting = true);
                try {
                  final result = await onConfirm();
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop(result ?? true);
                  }
                } catch (e) {
                  if (dialogContext.mounted) {
                    setDialogState(() => isSubmitting = false);
                    Navigator.of(dialogContext).pop(false);
                  }
                }
              } else {
                Navigator.of(dialogContext).pop(true);
              }
            },
          );
        },
      );
    },
  );
}
