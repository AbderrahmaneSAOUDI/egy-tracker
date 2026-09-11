import 'package:flutter/material.dart';
import '../../../core/components/c_add_expense_dialog.dart';
import '../../../core/components/c_delete_activity_dialog.dart';
import '../../../core/models/mod_activity_item.dart';
import '../../../core/models/mod_expense.dart';
import '../vm_my_tracker.dart';

/// Helper actions for opening expense edit and delete dialogs from My Tracker.
class MyTrackerActions {
  static void openEditExpenseDialog({
    required BuildContext context,
    required Expense expense,
    required String currentUserId,
    required MyTrackerViewModel viewModel,
  }) {
    final friendId =
        viewModel.friendProfile?.id ?? viewModel.friendEmailDoc?.email;
    final friendName =
        viewModel.friendProfile?.name ?? viewModel.friendEmailDoc?.email;
    final friendEmail = viewModel.friendEmailDoc?.email;

    showAddExpenseDialog(
      context: context,
      currentUserId: currentUserId,
      currentUserName: viewModel.myProfile?.name ?? 'You',
      friendUserId: friendId,
      friendUserName: friendName,
      friendUserEmail: friendEmail,
      myUsdBalance: viewModel.myUsdBalance,
      myEgpBalance: viewModel.myEgpBalance,
      friendUsdBalance: 0.0,
      friendEgpBalance: 0.0,
      initialExpense: expense,
      isPrimaryUser: viewModel.isPrimaryUser,
      onSave: (updated) => viewModel.updateExpense(updated),
    );
  }

  static void openDeleteExpenseDialog({
    required BuildContext context,
    required Expense expense,
    required MyTrackerViewModel viewModel,
  }) {
    showDeleteActivityDialog(
      context: context,
      item: ActivityItem.expense(expense),
      onDelete: () => viewModel.deleteExpense(expense.id),
    );
  }
}
