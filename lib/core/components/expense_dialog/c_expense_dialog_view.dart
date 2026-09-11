import 'package:flutter/material.dart';
import '../../theme/t_app_theme.dart';
import '../c_app_dialog.dart';
import 'c_expense_dialog_body.dart';
import 'c_expense_dialog_models.dart';
import 'c_expense_dialog_save_action.dart';
import 'c_expense_dialog_submit.dart';

/// Stateful view coordinator for the add/edit expense dialog.
class ExpenseDialogView extends StatefulWidget {
  final ExpenseDialogParams params;
  const ExpenseDialogView({super.key, required this.params});

  @override
  State<ExpenseDialogView> createState() => _ExpenseDialogViewState();
}

class _ExpenseDialogViewState extends State<ExpenseDialogView> {
  final _formKey = GlobalKey<FormState>();
  late String _currency;
  late String _paidBy;
  late String _splitType;
  late double _customMePct;
  late double _customFriendPct;
  late DateTime _selectedDate;
  bool _isSubmitting = false;

  ExpenseDialogParams get p => widget.params;

  @override
  void initState() {
    super.initState();
    final exp = p.initialExpense;
    _currency = exp?.currency ?? 'EGP';
    _paidBy = (exp != null && exp.paidBy == p.friendId) ? 'friend' : 'you';
    _splitType = exp?.splitType ?? 'default_100';
    _customMePct = exp != null ? (p.isPrimaryUser ? exp.mePercentage : exp.friendPercentage) : 50.0;
    _customFriendPct = exp != null ? (p.isPrimaryUser ? exp.friendPercentage : exp.mePercentage) : 50.0;
    _selectedDate = exp?.date ?? DateTime.now();
  }

  void _submit() => ExpenseSubmitHandler.submit(
        context: context, params: p, formKey: _formKey,
        selectedCurrency: _currency, paidBy: _paidBy, splitType: _splitType,
        customMePercentage: _customMePct, customFriendPercentage: _customFriendPct,
        selectedDate: _selectedDate, setSubmitting: (val) => setState(() => _isSubmitting = val),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyColor = _currency == 'USD'
        ? (isDark ? AppTheme.usdColorDark : AppTheme.usdColorLight)
        : (isDark ? AppTheme.egpColorDark : AppTheme.egpColorLight);

    final balances = ExpenseDialogBalances.calculate(
      selectedCurrency: _currency, myUsdBalance: p.myUsdBalance,
      myEgpBalance: p.myEgpBalance, friendUsdBalance: p.friendUsdBalance,
      friendEgpBalance: p.friendEgpBalance, initialExpense: p.initialExpense,
      currentUserId: p.currentUserId, friendId: p.friendId, friendName: p.friendName,
    );
    final splitState = ExpenseDialogSplitState(
      splitType: _splitType,
      customMePercentage: _customMePct,
      customFriendPercentage: _customFriendPct,
    );

    return AppDialog(
      icon: Icons.receipt_long_rounded,
      iconColor: isDark ? AppTheme.googleRedDark : AppTheme.googleRed,
      title: p.initialExpense != null ? 'Edit Expense' : 'Add Expense',
      actionLabel: 'Save',
      isSubmitting: _isSubmitting,
      onCancel: () => Navigator.of(p.dialogContext).pop(),
      onAction: _isSubmitting ? null : _submit,
      customAction: ExpenseSaveButton(
        titleController: p.titleController, amountController: p.amountController,
        splitState: splitState, isSubmitting: _isSubmitting, isDark: isDark, onSave: _submit,
      ),
      content: ExpenseDialogBody(
        formKey: _formKey, titleController: p.titleController, amountController: p.amountController,
        isSubmitting: _isSubmitting, selectedCurrency: _currency, currencyColor: currencyColor,
        isDark: isDark, paidBy: _paidBy, balances: balances, splitState: splitState,
        selectedDate: _selectedDate, onCurrencyChanged: (c) => setState(() => _currency = c),
        onPayerChanged: (p) => setState(() => _paidBy = p),
        onSplitTypeChanged: (s) => setState(() => _splitType = s),
        onCustomSplitChanged: (me, fr) => setState(() { _customMePct = me; _customFriendPct = fr; }),
        onDateChanged: (d) => setState(() => _selectedDate = d),
      ),
    );
  }
}
