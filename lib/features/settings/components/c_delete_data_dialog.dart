import 'package:flutter/material.dart';
import '../../../core/components/c_app_dialog.dart';

/// Shows modal dialog for confirming complete trip data deletion.
Future<void> showDeleteAllDataDialog({
  required BuildContext context,
  required Future<bool> Function() onDeleteAllData,
}) {
  bool isDeleting = false;

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final isDark = theme.brightness == Brightness.dark;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AppDialog(
            icon: Icons.warning_amber_rounded,
            iconColor: colorScheme.error,
            borderColor: colorScheme.error.withValues(alpha: isDark ? 0.4 : 0.3),
            title: 'Delete All Trip Data?',
            subtitle: 'Irreversible trip reset',
            subtitleColor: const Color(0xFFEA4335),
            actionLabel: 'Delete Everything',
            actionColor: colorScheme.error,
            actionForegroundColor: colorScheme.onError,
            isSubmitting: isDeleting,
            onCancel: () => Navigator.of(dialogContext).pop(),
            onAction: () async {
              final messenger = ScaffoldMessenger.of(context);
              final errorColor = colorScheme.error;
              setDialogState(() => isDeleting = true);

              final success = await onDeleteAllData();
              if (dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
              if (success) {
                messenger.showSnackBar(
                  SnackBar(
                    content: const Text(
                      'All trip data has been deleted.',
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              } else {
                messenger.showSnackBar(
                  SnackBar(
                    content: const Text('Failed to delete data'),
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
                  'This action is irreversible. All data from your trip will be permanently erased:',
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.03)
                        : Colors.black.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.error.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDataDeleteRow(
                        Icons.receipt_long_outlined,
                        'All Expenses (USD & EGP)',
                        colorScheme,
                      ),
                      const SizedBox(height: 6),
                      _buildDataDeleteRow(
                        Icons.currency_exchange_rounded,
                        'All Currency Exchanges',
                        colorScheme,
                      ),
                      const SizedBox(height: 6),
                      _buildDataDeleteRow(
                        Icons.account_balance_wallet_outlined,
                        'All Initial Balances',
                        colorScheme,
                      ),
                      const SizedBox(height: 6),
                      _buildDataDeleteRow(
                        Icons.people_outline_rounded,
                        'All User Profiles',
                        colorScheme,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your Google login access will remain active.',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildDataDeleteRow(
  IconData icon,
  String text,
  ColorScheme colorScheme,
) {
  return Row(
    children: [
      Icon(icon, size: 16, color: colorScheme.error),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    ],
  );
}
