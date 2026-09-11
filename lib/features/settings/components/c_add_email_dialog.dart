import 'package:flutter/material.dart';
import '../../../core/components/c_app_dialog.dart';
import '../../../core/utils/m_validators.dart';
import 'c_add_email_form.dart';

/// Shows modal dialog for adding an authorized email to the whitelist.
Future<void> showAddEmailDialog({
  required BuildContext context,
  required Future<bool> Function(String email) onAddEmail,
  String? initialEmail,
}) async {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(text: initialEmail ?? '');
  bool isSubmitting = false;

  final isEditing = initialEmail != null && initialEmail.isNotEmpty;

  await showAnimatedDialog<void>(
    context: context,
    disposables: [controller],
    builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;

            return AppDialog(
              icon: isEditing ? Icons.edit_rounded : Icons.person_add_rounded,
              title: isEditing ? 'Edit Allowed Email' : 'Add Allowed Email',
              actionLabel: isEditing ? 'Save' : 'Add',
              isSubmitting: isSubmitting,
              onCancel: () => Navigator.of(dialogContext).pop(),
            onAction: () async {
              if (!formKey.currentState!.validate()) return;
              final messenger = ScaffoldMessenger.of(context);
              final errorColor = colorScheme.error;
              final rawEmail = controller.text.trim();
              final email = Validators.normalizeEmail(rawEmail).toLowerCase();
              setDialogState(() => isSubmitting = true);

              final success = await onAddEmail(email);
              if (success) {
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(isEditing
                        ? 'Updated email to $email'
                        : 'Added $email to whitelist'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              } else {
                setDialogState(() => isSubmitting = false);
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(isEditing ? 'Failed to update email' : 'Failed to add email'),
                    backgroundColor: errorColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            content: AddEmailForm(
              formKey: formKey,
              controller: controller,
              isSubmitting: isSubmitting,
            ),
          );
        },
      );
    },
  );
}
