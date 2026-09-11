import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/components/c_add_exchange_dialog.dart';
import '../../../core/components/c_add_expense_dialog.dart';
import '../../../core/components/c_borrow_dialog.dart';
import '../../../core/components/c_delete_activity_dialog.dart';
import '../../../core/models/mod_activity_item.dart';
import '../vm_home_feed.dart';

/// Actions for editing and deleting activities from the Home tab.
class HomeTabActions {
  static void editItem({
    required BuildContext context,
    required ActivityItem item,
    required User user,
    required HomeFeedViewModel viewModel,
  }) {
    final friendId = viewModel.friendProfile?.id ?? viewModel.friendEmailDoc?.email;
    final friendUserName = viewModel.friendProfile?.name ?? viewModel.friendEmailDoc?.email;

    if (item.isExpense) {
      showAddExpenseDialog(
        context: context,
        currentUserId: user.uid,
        currentUserName: viewModel.myProfile?.name ?? 'You',
        friendUserId: friendId,
        friendUserName: friendUserName,
        myUsdBalance: viewModel.myUsdBalance,
        myEgpBalance: viewModel.myEgpBalance,
        friendUsdBalance: viewModel.friendUsdBalance,
        friendEgpBalance: viewModel.friendEgpBalance,
        initialExpense: item.expense,
        isPrimaryUser: viewModel.isPrimaryUser,
        onSave: viewModel.updateExpense,
      );
    } else if (item.isExchange) {
      showAddExchangeDialog(
        context: context,
        currentUserId: user.uid,
        currentUserName: viewModel.myProfile?.name ?? 'You',
        myUsdBalance: viewModel.myUsdBalance,
        myEgpBalance: viewModel.myEgpBalance,
        initialExchange: item.exchange,
        onSave: viewModel.updateExchange,
      );
    } else if (item.isBorrow) {
      showBorrowDialog(
        context: context,
        currentUserId: user.uid,
        currentUserName: viewModel.myProfile?.name ?? 'You',
        currentUserEmail: user.email,
        friendUserId: friendId,
        friendUserName: friendUserName,
        myUsdBalance: viewModel.myUsdBalance,
        myEgpBalance: viewModel.myEgpBalance,
        friendUsdBalance: viewModel.friendUsdBalance,
        friendEgpBalance: viewModel.friendEgpBalance,
        initialBorrow: item.borrow,
        onSave: viewModel.updateBorrow,
      );
    }
  }

  static void confirmDelete({
    required BuildContext context,
    required ActivityItem item,
    required HomeFeedViewModel viewModel,
  }) {
    showDeleteActivityDialog(
      context: context,
      item: item,
      onDelete: () async {
        if (item.isExpense) {
          await viewModel.deleteExpense(item.id);
        } else if (item.isExchange) {
          await viewModel.deleteExchange(item.id);
        } else {
          await viewModel.deleteBorrow(item.id);
        }
      },
    );
  }
}
