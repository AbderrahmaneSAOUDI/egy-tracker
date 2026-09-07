import 'package:flutter/material.dart';
import '../../../core/components/c_app_dialog.dart';
import '../../../core/theme/t_app_theme.dart';

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
}) {
  final formKey = GlobalKey<FormState>();
  final usdController = TextEditingController(
    text: currentUsd == 0
        ? ''
        : (currentUsd % 1 == 0
            ? currentUsd.toInt().toString()
            : currentUsd.toString()),
  );
  final egpController = TextEditingController(
    text: currentEgp == 0
        ? ''
        : (currentEgp % 1 == 0
            ? currentEgp.toInt().toString()
            : currentEgp.toString()),
  );
  bool isSubmitting = false;

  return showDialog<void>(
    context: context,
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
            subtitle: 'Starting cash for $userName',
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
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Starting physical cash before trip expenses begin. USD and EGP are kept strictly independent.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // USD Input
                  TextFormField(
                    controller: usdController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    enabled: !isSubmitting,
                    decoration: InputDecoration(
                      labelText: 'Starting USD (\$)',
                      hintText: '0.00',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.usdColorLight.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '\$',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppTheme.usdColorDark
                                  : AppTheme.usdColorLight,
                            ),
                          ),
                        ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.03),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (val) {
                      final trimmed = val?.trim() ?? '';
                      if (trimmed.isNotEmpty &&
                          double.tryParse(trimmed) == null) {
                        return 'Enter a valid amount';
                      }
                      if (trimmed.isNotEmpty &&
                          (double.tryParse(trimmed) ?? 0) < 0) {
                        return 'Amount must be positive';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // EGP Input
                  TextFormField(
                    controller: egpController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    enabled: !isSubmitting,
                    decoration: InputDecoration(
                      labelText: 'Starting EGP (EGP)',
                      hintText: '0.00',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.egpColorLight.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'EGP',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppTheme.egpColorDark
                                  : AppTheme.egpColorLight,
                            ),
                          ),
                        ),
                      ),
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                      filled: true,
                      fillColor: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.03),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    validator: (val) {
                      final trimmed = val?.trim() ?? '';
                      if (trimmed.isNotEmpty &&
                          double.tryParse(trimmed) == null) {
                        return 'Enter a valid amount';
                      }
                      if (trimmed.isNotEmpty &&
                          (double.tryParse(trimmed) ?? 0) < 0) {
                        return 'Amount must be positive';
                      }
                      return null;
                    },
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
