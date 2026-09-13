import 'package:flutter/material.dart';
import 'c_app_snack_bar.dart';
import 'c_confirmation_dialog.dart';
import '../models/mod_activity_item.dart';
import '../utils/m_formatters.dart';

/// Shows a standardized confirmation dialog for deleting an activity item
/// (Expense, Exchange, or Borrow record).
Future<void> showDeleteActivityDialog({
  required BuildContext context,
  required ActivityItem item,
  required Future<void> Function() onDelete,
}) {
  String title;
  String name;
  IconData icon;

  if (item.isExpense) {
    title = 'Delete Expense';
    name = item.expense!.title;
    icon = Icons.receipt_long_rounded;
  } else if (item.isExchange) {
    title = 'Delete Exchange';
    name =
        '${Formatters.formatCurrency(item.exchange!.fromAmount, item.exchange!.fromCurrency)} → ${Formatters.formatCurrency(item.exchange!.toAmount, item.exchange!.toCurrency)}';
    icon = Icons.sync_alt_rounded;
  } else {
    title = 'Delete Borrow Record';
    final borrow = item.borrow!;
    final parts = <String>[];
    if (borrow.usdAmount > 0) parts.add(Formatters.formatUsd(borrow.usdAmount));
    if (borrow.egpAmount > 0) parts.add(Formatters.formatEgp(borrow.egpAmount));
    name = parts.isNotEmpty ? parts.join(' & ') : 'borrow record';
    icon = Icons.handshake_rounded;
  }

  return showConfirmationDialog(
    context: context,
    title: title,
    message: 'Are you sure you want to delete "$name"? Cash balances will be updated.',
    confirmLabel: 'Delete',
    cancelLabel: 'Cancel',
    icon: icon,
    isDestructive: true,
    onConfirm: () async {
      await onDelete();
      if (context.mounted) {
        AppSnackBar.show(
          context,
          message: 'Deleted "$name"',
          type: AppSnackBarType.info,
        );
      }
      return true;
    },
  );
}
