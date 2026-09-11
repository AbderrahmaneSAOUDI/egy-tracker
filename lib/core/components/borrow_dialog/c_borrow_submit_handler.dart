import 'package:flutter/material.dart';
import '../../models/mod_borrow.dart';
import '../../utils/m_formatters.dart';

/// Handler for executing borrow dialog save action.
class BorrowSubmitHandler {
  static Future<void> submit({
    required BuildContext context,
    required BuildContext dialogContext,
    required bool isBorrowMode,
    required String currentUserId,
    required String friendId,
    required String friendName,
    required double usd,
    required double egp,
    required DateTime selectedDate,
    required Borrow? initialBorrow,
    required Future<bool> Function(Borrow) onSave,
    required void Function(bool) setSubmitting,
  }) async {
    if (usd <= 0 && egp <= 0) return;

    setSubmitting(true);
    final actualBorrowerId = isBorrowMode ? currentUserId : friendId;
    final actualLenderId = isBorrowMode ? friendId : currentUserId;

    final borrow = Borrow(
      id: initialBorrow?.id ?? '',
      borrowerId: actualBorrowerId,
      lenderId: actualLenderId,
      usdAmount: usd,
      egpAmount: egp,
      date: selectedDate,
      createdAt: initialBorrow?.createdAt ?? DateTime.now(),
    );

    final success = await onSave(borrow);
    if (dialogContext.mounted && success) {
      Navigator.of(dialogContext).pop();
      final actionText = isBorrowMode ? 'borrow from $friendName' : 'loan to $friendName';
      final usdText = usd > 0 ? Formatters.formatUsd(usd) : '';
      final egpText = egp > 0 ? Formatters.formatEgp(egp) : '';
      final andText = (usd > 0 && egp > 0) ? ' and ' : '';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(initialBorrow != null
              ? 'Updated $actionText: $usdText$andText$egpText'
              : 'Recorded $actionText: $usdText$andText$egpText'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (dialogContext.mounted) {
      setSubmitting(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save borrow record. Please check your connection and try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
