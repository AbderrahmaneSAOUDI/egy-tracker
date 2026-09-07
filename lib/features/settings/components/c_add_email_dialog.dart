import 'package:flutter/material.dart';
import '../../../core/components/c_app_dialog.dart';
import '../../../core/utils/m_validators.dart';

/// Shows modal dialog for adding an authorized email to the whitelist.
Future<void> showAddEmailDialog({
  required BuildContext context,
  required Future<bool> Function(String email) onAddEmail,
}) {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  bool isSubmitting = false;

  return showAnimatedDialog<void>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          final isDark = theme.brightness == Brightness.dark;

          return AppDialog(
            icon: Icons.person_add_rounded,
            title: 'Add Allowed Email',
            actionLabel: 'Add',
            isSubmitting: isSubmitting,
            onCancel: () => Navigator.of(dialogContext).pop(),
            onAction: () async {
              if (!formKey.currentState!.validate()) return;
              final messenger = ScaffoldMessenger.of(context);
              final errorColor = colorScheme.error;
              final email = controller.text.trim().toLowerCase();
              setDialogState(() => isSubmitting = true);

              final success = await onAddEmail(email);
              if (success) {
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Added $email to whitelist'),
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
                    content: const Text('Failed to add email'),
                    backgroundColor: errorColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grant a travel partner access to this Egypt expense tracker with their Google account.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    autocorrect: false,
                    enabled: !isSubmitting,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'partner@gmail.com',
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.03),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: Validators.validateEmail,
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
