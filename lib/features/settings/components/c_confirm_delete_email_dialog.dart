import 'package:flutter/material.dart';
import '../../../core/components/c_app_snack_bar.dart';
import '../../../core/components/c_alert_banner.dart';
import '../../../core/components/c_confirmation_dialog.dart';
import '../../../core/models/mod_allowed_email.dart';

/// Shows confirmation dialog for removing an email from the whitelist.
Future<void> showConfirmDeleteEmailDialog({
  required BuildContext context,
  required AllowedEmail allowedEmail,
  required bool isCurrentUser,
  required Future<bool> Function(String id) onDeleteEmail,
}) async {
  await showConfirmationDialog(
    context: context,
    icon: Icons.person_remove_rounded,
    title: 'Remove Allowed Email?',
    message: 'Are you sure you want to remove ${allowedEmail.email}?',
    confirmLabel: 'Remove',
    cancelLabel: 'Cancel',
    isDestructive: true,
    additionalContent: isCurrentUser
        ? const AlertBanner(
            message:
                'Warning: Removing your own email may prevent you from logging in again!',
            severity: AlertSeverity.error,
            customIcon: Icons.warning_amber_rounded,
          )
        : null,
    onConfirm: () async {
      final success = await onDeleteEmail(allowedEmail.id);
      if (context.mounted) {
        if (success) {
          AppSnackBar.show(
            context,
            message: 'Removed ${allowedEmail.email}',
            type: AppSnackBarType.info,
          );
        } else {
          AppSnackBar.show(
            context,
            message: 'Failed to delete email',
            type: AppSnackBarType.error,
          );
        }
      }
      return success;
    },
  );
}
