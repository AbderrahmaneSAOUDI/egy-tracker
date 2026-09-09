import 'dart:async';
import 'package:flutter/material.dart';
import 'c_app_dialog.dart';

/// Reusable confirmation dialog component for all destructive or confirmation popups
/// across the application, ensuring uniform styling, icon badges, and action buttons.
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? message;
  final Widget? additionalContent;
  final String confirmLabel;
  final String cancelLabel;
  final IconData icon;
  final Color? iconColor;
  final Color? confirmColor;
  final Color? confirmForegroundColor;
  final Color? borderColor;
  final bool isDestructive;
  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.message,
    this.additionalContent,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.icon = Icons.warning_amber_rounded,
    this.iconColor,
    this.confirmColor,
    this.confirmForegroundColor,
    this.borderColor,
    this.isDestructive = true,
    this.isSubmitting = false,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final effectiveIconColor = iconColor ??
        (isDestructive ? colorScheme.error : colorScheme.primary);

    final effectiveActionColor = confirmColor ??
        (isDestructive ? colorScheme.error : colorScheme.primary);

    final effectiveActionFg = confirmForegroundColor ??
        (isDestructive ? colorScheme.onError : colorScheme.onPrimary);

    final effectiveBorderColor = borderColor ??
        (isDestructive
            ? colorScheme.error.withValues(alpha: isDark ? 0.35 : 0.25)
            : null);

    return AppDialog(
      icon: icon,
      iconColor: effectiveIconColor,
      borderColor: effectiveBorderColor,
      title: title,
      subtitle: subtitle,
      actionLabel: confirmLabel,
      cancelLabel: cancelLabel,
      actionColor: effectiveActionColor,
      actionForegroundColor: effectiveActionFg,
      isSubmitting: isSubmitting,
      onCancel: onCancel,
      onAction: onConfirm,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message != null) ...[
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
          ],
          if (additionalContent != null) ...[
            if (message != null) const SizedBox(height: 14),
            additionalContent!,
          ],
        ],
      ),
    );
  }
}

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
                final result = await onConfirm();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop(result ?? true);
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
