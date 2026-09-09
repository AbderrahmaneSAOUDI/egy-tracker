import 'package:flutter/material.dart';
import 'c_confirmation_dialog.dart';
import '../models/mod_activity_item.dart';

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
    name = 'this exchange';
    icon = Icons.sync_alt_rounded;
  } else {
    title = 'Delete Borrow Record';
    name = 'this borrow record';
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
      return true;
    },
  );
}
