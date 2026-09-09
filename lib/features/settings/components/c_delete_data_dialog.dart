import 'package:flutter/material.dart';
import '../../../core/components/c_confirmation_dialog.dart';

/// Shows modal dialog for confirming complete trip data deletion.
Future<void> showDeleteAllDataDialog({
  required BuildContext context,
  required Future<bool> Function() onDeleteAllData,
}) async {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final isDark = theme.brightness == Brightness.dark;
  final messenger = ScaffoldMessenger.of(context);
  final errorColor = colorScheme.error;

  final additionalContent = Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
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
  );

  await showConfirmationDialog(
    context: context,
    icon: Icons.warning_amber_rounded,
    title: 'Delete All Trip Data?',
    message:
        'This action is irreversible. All data from your trip will be permanently erased:',
    additionalContent: additionalContent,
    confirmLabel: 'Delete Everything',
    cancelLabel: 'Cancel',
    isDestructive: true,
    onConfirm: () async {
      final success = await onDeleteAllData();
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
      return success;
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
