import 'package:flutter/material.dart';
import '../../../core/components/c_alert_banner.dart';
import '../../../core/components/c_app_dialog.dart';
import '../../../core/models/mod_allowed_email.dart';

/// Shows confirmation dialog for removing an email from the whitelist.
Future<void> showConfirmDeleteEmailDialog({
  required BuildContext context,
  required AllowedEmail allowedEmail,
  required bool isCurrentUser,
  required Future<bool> Function(String id) onDeleteEmail,
}) {
  bool isSubmitting = false;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final isDark = theme.brightness == Brightness.dark;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AppDialog(
            icon: Icons.person_remove_rounded,
            iconColor: colorScheme.error,
            borderColor: colorScheme.error.withValues(alpha: isDark ? 0.35 : 0.25),
            title: 'Remove Allowed Email?',
            subtitle: 'Revoke whitelist access',
            subtitleColor: colorScheme.error,
            actionLabel: 'Remove',
            actionColor: colorScheme.error,
            actionForegroundColor: colorScheme.onError,
            isSubmitting: isSubmitting,
            onCancel: () => Navigator.of(dialogContext).pop(),
            onAction: () async {
              final messenger = ScaffoldMessenger.of(context);
              final errorColor = colorScheme.error;
              setDialogState(() => isSubmitting = true);

              final success = await onDeleteEmail(allowedEmail.id);
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              if (success) {
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Removed ${allowedEmail.email}'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              } else {
                messenger.showSnackBar(
                  SnackBar(
                    content: const Text('Failed to delete email'),
                    backgroundColor: errorColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure you want to remove ${allowedEmail.email}?',
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
                if (isCurrentUser) ...[
                  const SizedBox(height: 14),
                  const AlertBanner(
                    message:
                        'Warning: Removing your own email may prevent you from logging in again!',
                    severity: AlertSeverity.error,
                    customIcon: Icons.warning_amber_rounded,
                  ),
                ],
              ],
            ),
          );
        },
      );
    },
  );
}
