import 'package:flutter/material.dart';
import '../../../core/components/c_app_snack_bar.dart';
import '../../../core/components/c_app_dialog.dart';
import '../../../core/utils/m_validators.dart';
import 'c_add_email_form.dart';

/// Shows modal dialog for adding an authorized email to the whitelist.
Future<void> showAddEmailDialog({
  required BuildContext context,
  required Future<bool> Function(String email) onAddEmail,
  String? initialEmail,
  String? Function()? getErrorMessage,
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
            Future<void> doSubmit() async {
              if (isSubmitting) return;
              if (!formKey.currentState!.validate()) return;
              final rawEmail = controller.text.trim();
              final email = Validators.normalizeEmail(rawEmail).toLowerCase();
              setDialogState(() => isSubmitting = true);

              final success = await onAddEmail(email);
              if (!context.mounted) return;
              if (success) {
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
                AppSnackBar.show(
                  context,
                  message: isEditing
                      ? 'Updated email to $email'
                      : 'Added $email to whitelist',
                  type: AppSnackBarType.success,
                );
              } else {
                setDialogState(() => isSubmitting = false);
                final failureMsg = isEditing
                    ? 'Failed to update email'
                    : (getErrorMessage?.call() ?? 'Failed to add email');
                AppSnackBar.show(
                  context,
                  message: failureMsg,
                  type: AppSnackBarType.error,
                );
              }
            }

            return AppDialog(
              icon: isEditing ? Icons.edit_rounded : Icons.person_add_rounded,
              title: isEditing ? 'Edit Allowed Email' : 'Add Allowed Email',
              actionLabel: isEditing ? 'Save' : 'Add',
              isSubmitting: isSubmitting,
              onCancel: () => Navigator.of(dialogContext).pop(),
              onAction: isSubmitting ? null : doSubmit,
              content: AddEmailForm(
                formKey: formKey,
                controller: controller,
                isSubmitting: isSubmitting,
                onSubmit: isSubmitting ? null : doSubmit,
              ),
            );
          },
      );
    },
  );
}
