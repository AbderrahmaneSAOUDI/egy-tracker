import 'package:flutter/material.dart';
import '../../models/mod_expense.dart';

/// Balance information for payer sufficiency warnings in the expense dialog.
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
  }) {
    final myAvail = selectedCurrency == 'USD' ? myUsdBalance : myEgpBalance;
    final frAvail = selectedCurrency == 'USD' ? friendUsdBalance : friendEgpBalance;
    final effMy = myAvail +
        (initialExpense != null &&
                initialExpense.currency == selectedCurrency &&
                initialExpense.paidBy == currentUserId
            ? initialExpense.amount
            : 0.0);
    final effFr = frAvail +
        (initialExpense != null &&
                initialExpense.currency == selectedCurrency &&
                initialExpense.paidBy == friendId
            ? initialExpense.amount
            : 0.0);
    return ExpenseDialogBalances(
      effectiveMyAvailable: effMy,
      effectiveFriendAvailable: effFr,
      friendAvailableCash: frAvail,
      friendName: friendName,
    );
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
