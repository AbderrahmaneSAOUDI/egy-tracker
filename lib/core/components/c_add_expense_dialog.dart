import 'package:flutter/material.dart';
import '../models/mod_expense.dart';
import 'c_app_dialog.dart';
import 'expense_dialog/c_expense_dialog_models.dart';
import 'expense_dialog/c_expense_dialog_view.dart';

export 'expense_dialog/c_expense_dialog_body.dart';
export 'expense_dialog/c_expense_dialog_custom_slider.dart';
export 'expense_dialog/c_expense_dialog_date.dart';
export 'expense_dialog/c_expense_dialog_fields.dart';
export 'expense_dialog/c_expense_dialog_models.dart';
export 'expense_dialog/c_expense_dialog_payer.dart';
export 'expense_dialog/c_expense_dialog_save_action.dart';
export 'expense_dialog/c_expense_dialog_split.dart';
export 'expense_dialog/c_expense_dialog_submit.dart';
export 'expense_dialog/c_expense_dialog_view.dart';
export 'expense_dialog/c_expense_dialog_warning.dart';
export 'expense_dialog/c_expense_dialog_widgets.dart';

/// Shows modal dialog for creating a new expense with dynamic split visibility
/// and balance sufficiency hints.
Future<void> showAddExpenseDialog({
  required BuildContext context,
  required String currentUserId,
  required String currentUserName,
  String? friendUserId,
  String? friendUserName,
  String? friendUserEmail,
  double myUsdBalance = 0.0,
  double myEgpBalance = 0.0,
  double friendUsdBalance = 0.0,
  double friendEgpBalance = 0.0,
  Expense? initialExpense,
  bool isPrimaryUser = true,
  required Future<bool> Function(Expense) onSave,
}) async {
  final titleController = TextEditingController(text: initialExpense?.title ?? '');
  final amountController = TextEditingController(
    text: initialExpense != null ? initialExpense.amount.toStringAsFixed(2) : '',
  );

  final friendId = friendUserId ?? (friendUserEmail?.trim().isNotEmpty == true ? friendUserEmail!.trim() : 'friend');
  final friendName = friendUserName ?? 'Friend';

  await showAnimatedDialog<void>(
    context: context,
    disposables: [titleController, amountController],
    builder: (dialogContext) {
      return ExpenseDialogView(
        params: ExpenseDialogParams(
          dialogContext: dialogContext,
          currentUserId: currentUserId,
          currentUserName: currentUserName,
          friendId: friendId,
          friendName: friendName,
          myUsdBalance: myUsdBalance,
          myEgpBalance: myEgpBalance,
          friendUsdBalance: friendUsdBalance,
          friendEgpBalance: friendEgpBalance,
          initialExpense: initialExpense,
          isPrimaryUser: isPrimaryUser,
          titleController: titleController,
          amountController: amountController,
          onSave: onSave,
        ),
      );
    },
  );
}
