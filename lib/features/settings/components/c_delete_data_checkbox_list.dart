import 'package:flutter/material.dart';
import 'c_delete_data_checkbox_row.dart';
import 'c_delete_data_selection.dart';

/// Styled container displaying the list of data category checkboxes.
class DeleteDataCheckboxList extends StatelessWidget {
  final DeleteDataSelection selection;
  final VoidCallback onChanged;

  const DeleteDataCheckboxList({
    super.key,
    required this.selection,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(8),
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
        children: [
          DeleteDataCheckboxRow(
            icon: Icons.receipt_long_outlined,
            label: 'All Expenses (USD & EGP)',
            value: selection.deleteExpenses,
            onChanged: (v) {
              selection.deleteExpenses = v ?? false;
              onChanged();
            },
            colorScheme: colorScheme,
          ),
          const Divider(height: 6, thickness: 0.5),
          DeleteDataCheckboxRow(
            icon: Icons.currency_exchange_rounded,
            label: 'All Currency Exchanges',
            value: selection.deleteExchanges,
            onChanged: (v) {
              selection.deleteExchanges = v ?? false;
              onChanged();
            },
            colorScheme: colorScheme,
          ),
          const Divider(height: 6, thickness: 0.5),
          DeleteDataCheckboxRow(
            icon: Icons.handshake_outlined,
            label: 'All Borrow & Lend Records',
            value: selection.deleteBorrows,
            onChanged: (v) {
              selection.deleteBorrows = v ?? false;
              onChanged();
            },
            colorScheme: colorScheme,
          ),
          const Divider(height: 6, thickness: 0.5),
          DeleteDataCheckboxRow(
            icon: Icons.account_balance_wallet_outlined,
            label: 'All Initial Balances',
            value: selection.deleteInitialBalances,
            onChanged: (v) {
              selection.deleteInitialBalances = v ?? false;
              onChanged();
            },
            colorScheme: colorScheme,
          ),
          const Divider(height: 6, thickness: 0.5),
          DeleteDataCheckboxRow(
            icon: Icons.group_remove_outlined,
            label: 'Trip Members & Whitelisted Friends',
            value: selection.deleteFriends,
            onChanged: (v) {
              selection.deleteFriends = v ?? false;
              onChanged();
            },
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}
