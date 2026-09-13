import 'package:flutter/material.dart';
import '../../models/mod_expense.dart';
import '../../utils/m_formatters.dart';

/// Balance information for payer sufficiency and overdraft checks in the expense dialog.
class ExpenseDialogBalances {
  final double effectiveMyAvailable;
  final double effectiveFriendAvailable;
  final double friendAvailableCash;
  final String friendName;

  const ExpenseDialogBalances({
    required this.effectiveMyAvailable,
    required this.effectiveFriendAvailable,
    required this.friendAvailableCash,
    required this.friendName,
  });

  factory ExpenseDialogBalances.calculate({
    required String selectedCurrency,
    required double myUsdBalance,
    required double myEgpBalance,
    required double friendUsdBalance,
    required double friendEgpBalance,
    required Expense? initialExpense,
    required String currentUserId,
    required String friendId,
    required String friendName,
    bool isPrimaryUser = true,
  }) {
    final myAvail = selectedCurrency == 'USD' ? myUsdBalance : myEgpBalance;
    final frAvail = selectedCurrency == 'USD' ? friendUsdBalance : friendEgpBalance;

    double myRefund = 0.0;
    double friendRefund = 0.0;

    if (initialExpense != null && initialExpense.currency == selectedCurrency) {
      final isInitialSplit = (initialExpense.splitType == 'fifty_fifty') ||
          (initialExpense.splitType == 'custom' &&
              initialExpense.mePercentage > 0 &&
              initialExpense.friendPercentage > 0);

      if (isInitialSplit) {
        final myPct = isPrimaryUser
            ? initialExpense.mePercentage
            : initialExpense.friendPercentage;
        final friendPct = isPrimaryUser
            ? initialExpense.friendPercentage
            : initialExpense.mePercentage;
        myRefund = initialExpense.amount * (myPct / 100.0);
        friendRefund = initialExpense.amount * (friendPct / 100.0);
      } else {
        if (initialExpense.paidBy == currentUserId) {
          myRefund = initialExpense.amount;
        } else if (initialExpense.paidBy == friendId) {
          friendRefund = initialExpense.amount;
        }
      }
    }

    return ExpenseDialogBalances(
      effectiveMyAvailable: myAvail + myRefund,
      effectiveFriendAvailable: frAvail + friendRefund,
      friendAvailableCash: frAvail,
      friendName: friendName,
    );
  }

  /// Returns null if valid, or a user-facing error message if amount causes an overdraft.
  String? getOverdraftError({
    required double amount,
    required String splitType,
    required double customMePercentage,
    required double customFriendPercentage,
    required String paidBy,
    required String currency,
  }) {
    if (amount <= 0) return null;

    final isSplit = splitType == 'fifty_fifty' || splitType == 'custom';
    if (isSplit) {
      final mePct = splitType == 'fifty_fifty' ? 50.0 : customMePercentage;
      final friendPct = splitType == 'fifty_fifty' ? 50.0 : customFriendPercentage;
      final myShare = amount * (mePct / 100.0);
      final friendShare = amount * (friendPct / 100.0);

      if (mePct > 0 && myShare > effectiveMyAvailable) {
        return 'Your share (${Formatters.formatCurrency(myShare, currency)}) exceeds your available cash (${Formatters.formatCurrency(effectiveMyAvailable, currency)})';
      }
      if (friendPct > 0 && friendShare > effectiveFriendAvailable) {
        return '$friendName\'s share (${Formatters.formatCurrency(friendShare, currency)}) exceeds available cash (${Formatters.formatCurrency(effectiveFriendAvailable, currency)})';
      }
      return null;
    } else {
      final isMe = paidBy == 'you';
      final payerAvailable = isMe ? effectiveMyAvailable : effectiveFriendAvailable;
      if (amount > payerAvailable) {
        if (isMe) {
          return 'Amount exceeds your available cash (${Formatters.formatCurrency(effectiveMyAvailable, currency)})';
        } else {
          return 'Amount exceeds $friendName\'s available cash (${Formatters.formatCurrency(effectiveFriendAvailable, currency)})';
        }
      }
      return null;
    }
  }

  bool isOverdraft({
    required double amount,
    required String splitType,
    required double customMePercentage,
    required double customFriendPercentage,
    required String paidBy,
    required String currency,
  }) {
    return getOverdraftError(
      amount: amount,
      splitType: splitType,
      customMePercentage: customMePercentage,
      customFriendPercentage: customFriendPercentage,
      paidBy: paidBy,
      currency: currency,
    ) != null;
  }
}

/// Split configuration state for the expense dialog.
class ExpenseDialogSplitState {
  final String splitType;
  final double customMePercentage;
  final double customFriendPercentage;

  const ExpenseDialogSplitState({
    required this.splitType,
    required this.customMePercentage,
    required this.customFriendPercentage,
  });
}

/// Parameters passed into the expense dialog view.
class ExpenseDialogParams {
  final BuildContext dialogContext;
  final String currentUserId;
  final String currentUserName;
  final String friendId;
  final String friendName;
  final double myUsdBalance;
  final double myEgpBalance;
  final double friendUsdBalance;
  final double friendEgpBalance;
  final Expense? initialExpense;
  final bool isPrimaryUser;
  final TextEditingController titleController;
  final TextEditingController amountController;
  final Future<bool> Function(Expense) onSave;

  const ExpenseDialogParams({
    required this.dialogContext,
    required this.currentUserId,
    required this.currentUserName,
    required this.friendId,
    required this.friendName,
    required this.myUsdBalance,
    required this.myEgpBalance,
    required this.friendUsdBalance,
    required this.friendEgpBalance,
    required this.initialExpense,
    required this.isPrimaryUser,
    required this.titleController,
    required this.amountController,
    required this.onSave,
  });
}
