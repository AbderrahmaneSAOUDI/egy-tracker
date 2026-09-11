import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/mod_expense.dart';
import 'c_expense_dialog_models.dart';
import 'c_expense_dialog_validation.dart';

/// Handles validation, calculation, and persistence for an expense form.
class ExpenseSubmitHandler {
  static Future<void> submit({
    required BuildContext context,
    required ExpenseDialogParams params,
    required GlobalKey<FormState> formKey,
    required String selectedCurrency,
    required String paidBy,
    required String splitType,
    required double customMePercentage,
    required double customFriendPercentage,
    required DateTime selectedDate,
    required void Function(bool) setSubmitting,
  }) async {
    if (!formKey.currentState!.validate()) return;

    final pcts = ExpenseSplitCalculator.calculatePercentages(
      context: context,
      splitType: splitType,
      paidBy: paidBy,
      isPrimaryUser: params.isPrimaryUser,
      customMePercentage: customMePercentage,
      customFriendPercentage: customFriendPercentage,
    );
    if (pcts == null) return;

    final amount = double.tryParse(params.amountController.text.trim()) ?? 0.0;
    setSubmitting(true);

    final actualPayerId = paidBy == 'friend' ? params.friendId : params.currentUserId;
    final initial = params.initialExpense;
    final generatedId = (initial != null && initial.id.isNotEmpty)
        ? initial.id
        : DateTime.now().microsecondsSinceEpoch.toString();
    final expense = Expense(
      id: generatedId,
      title: params.titleController.text.trim(),
      amount: amount,
      currency: selectedCurrency,
      paidBy: actualPayerId,
      splitType: splitType,
      mePercentage: pcts.$1,
      friendPercentage: pcts.$2,
      date: selectedDate,
      createdAt: initial?.createdAt ?? DateTime.now(),
      createdBy: initial?.createdBy.isNotEmpty == true ? initial!.createdBy : params.currentUserId,
    );

    final success = await params.onSave(expense);
    if (!context.mounted) return;
    if (params.dialogContext.mounted && success) {
      HapticFeedback.lightImpact();
      Navigator.of(params.dialogContext).pop();
      String confirmationText;
      if (initial != null) {
        final changes = <String>[];
        if (initial.amount != expense.amount || initial.currency != expense.currency) {
          changes.add('${initial.amount.toStringAsFixed(2)} ${initial.currency} → ${expense.amount.toStringAsFixed(2)} ${expense.currency}');
        }
        if (initial.title != expense.title) {
          changes.add('"${initial.title}" → "${expense.title}"');
        }
        confirmationText = changes.isNotEmpty
            ? 'Updated: ${changes.join(', ')}'
            : 'Updated expense: ${expense.title}';
      } else {
        confirmationText = 'Added expense: ${expense.title}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(confirmationText),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (params.dialogContext.mounted) {
      setSubmitting(false);
    }
  }
}
