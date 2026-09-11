import 'package:flutter/material.dart';
import 'c_expense_dialog_date.dart';
import 'c_expense_dialog_fields.dart';
import 'c_expense_dialog_models.dart';
import 'c_expense_dialog_payer.dart';
import 'c_expense_dialog_split.dart';
import 'c_expense_dialog_warning.dart';

/// Form body layout for the add/edit expense dialog.
class ExpenseDialogBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController amountController;
  final bool isSubmitting;
  final String selectedCurrency;
  final Color currencyColor;
  final bool isDark;
  final String paidBy;
  final ExpenseDialogBalances balances;
  final ExpenseDialogSplitState splitState;
  final DateTime selectedDate;
  final ValueChanged<String> onCurrencyChanged;
  final ValueChanged<String> onPayerChanged;
  final ValueChanged<String> onSplitTypeChanged;
  final void Function(double, double) onCustomSplitChanged;
  final ValueChanged<DateTime> onDateChanged;

  const ExpenseDialogBody({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.amountController,
    required this.isSubmitting,
    required this.selectedCurrency,
    required this.currencyColor,
    required this.isDark,
    required this.paidBy,
    required this.balances,
    required this.splitState,
    required this.selectedDate,
    required this.onCurrencyChanged,
    required this.onPayerChanged,
    required this.onSplitTypeChanged,
    required this.onCustomSplitChanged,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpenseDialogFields(
                titleController: titleController,
                amountController: amountController,
                isSubmitting: isSubmitting,
                selectedCurrency: selectedCurrency,
                currencyColor: currencyColor,
                isDark: isDark,
                onCurrencyChanged: onCurrencyChanged,
              ),
              ExpenseCashWarning(
                amountController: amountController,
                paidBy: paidBy,
                effectiveMyAvailable: balances.effectiveMyAvailable,
                effectiveFriendAvailable: balances.effectiveFriendAvailable,
                friendAvailableCash: balances.friendAvailableCash,
                friendName: balances.friendName,
                selectedCurrency: selectedCurrency,
                isDark: isDark,
              ),
              const SizedBox(height: 14),
              ExpensePayerSelector(
                paidBy: paidBy,
                friendName: balances.friendName,
                isDark: isDark,
                onPayerChanged: onPayerChanged,
              ),
              const SizedBox(height: 14),
              ExpenseSplitSelector(
                splitType: splitState.splitType,
                customMePercentage: splitState.customMePercentage,
                customFriendPercentage: splitState.customFriendPercentage,
                friendName: balances.friendName,
                isDark: isDark,
                onSplitTypeChanged: onSplitTypeChanged,
                onCustomPercentageChanged: onCustomSplitChanged,
              ),
              const SizedBox(height: 16),
              ExpenseDatePicker(
                selectedDate: selectedDate,
                onDateChanged: onDateChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
