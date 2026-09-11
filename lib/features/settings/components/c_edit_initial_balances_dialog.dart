import 'package:flutter/material.dart';
import '../../../core/components/c_app_dialog.dart';
import '../../../core/theme/t_app_theme.dart';
import 'c_edit_initial_balances_form.dart';

/// Shows modal dialog for configuring starting cash (USD & EGP).
Future<void> showEditInitialBalancesDialog({
  required BuildContext context,
  required String userId,
  required String userName,
  required double currentUsd,
  required double currentEgp,
  required Future<void> Function({
    required String userId,
    required double usdAmount,
    required double egpAmount,
  }) onSave,
}) async {
  final formKey = GlobalKey<FormState>();
  String format(double v) =>
      v == 0 ? '' : (v % 1 == 0 ? v.toInt().toString() : v.toString());
  final usdController = TextEditingController(text: format(currentUsd));
  final egpController = TextEditingController(text: format(currentEgp));
  bool isSubmitting = false;

  await showAnimatedDialog<void>(
    context: context,
    disposables: [usdController, egpController],
    builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;
            final isDark = theme.brightness == Brightness.dark;

            return AppDialog(
            icon: Icons.account_balance_wallet_rounded,
            iconColor: isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight,
            title: 'Initial Balances',
            actionLabel: 'Save',
            isSubmitting: isSubmitting,
            onCancel: () => Navigator.of(dialogContext).pop(),
            onAction: () async {
              if (!formKey.currentState!.validate()) return;
              final messenger = ScaffoldMessenger.of(context);
              final errorColor = colorScheme.error;
              final usd = double.tryParse(usdController.text.trim()) ?? 0.0;
              final egp = double.tryParse(egpController.text.trim()) ?? 0.0;
              setDialogState(() => isSubmitting = true);

              try {
                await onSave(
                  userId: userId,
                  usdAmount: usd,
                  egpAmount: egp,
                );
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      'Updated starting balances for $userName',
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              } catch (e) {
                setDialogState(() => isSubmitting = false);
                messenger.showSnackBar(
                  SnackBar(
                    content: Text('Failed to save balances: $e'),
                    backgroundColor: errorColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            content: EditInitialBalancesForm(
              formKey: formKey,
              usdController: usdController,
              egpController: egpController,
              isSubmitting: isSubmitting,
              isDark: isDark,
              colorScheme: colorScheme,
            ),
          );
        },
      );
    },
  );
}
