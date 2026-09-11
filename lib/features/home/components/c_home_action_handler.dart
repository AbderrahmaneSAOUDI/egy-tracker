import 'package:flutter/material.dart';
import '../../../core/components/c_add_action_sheet.dart';
import '../../../core/components/c_add_exchange_dialog.dart';
import '../../../core/components/c_add_expense_dialog.dart';
import '../../../core/components/c_borrow_dialog.dart';
import '../vm_home_feed.dart';

/// Coordinator for opening modal dialogs and sheets from the Home screen floating nav bar.
class HomeActionHandler {
  static void openExchange({
    required BuildContext context,
    required String currentUserId,
    required HomeFeedViewModel feedViewModel,
  }) {
    showAddExchangeDialog(
      context: context,
      currentUserId: currentUserId,
      currentUserName: feedViewModel.myProfile?.name ?? 'You',
      myUsdBalance: feedViewModel.myUsdBalance,
      myEgpBalance: feedViewModel.myEgpBalance,
      onSave: feedViewModel.addExchange,
    );
  }

  static void openAddSheet({
    required BuildContext context,
    required String currentUserId,
    required HomeFeedViewModel feedViewModel,
  }) {
    showAddActionSheet(
      context: context,
      onAddExpense: () {
        final friendId = feedViewModel.friendProfile?.id ?? feedViewModel.friendEmailDoc?.email;
        final friendName = feedViewModel.friendProfile?.name ?? feedViewModel.friendEmailDoc?.email;

        showAddExpenseDialog(
          context: context,
          currentUserId: currentUserId,
          currentUserName: feedViewModel.myProfile?.name ?? 'You',
          friendUserId: friendId,
          friendUserName: friendName,
          friendUserEmail: feedViewModel.friendEmailDoc?.email,
          myUsdBalance: feedViewModel.myUsdBalance,
          myEgpBalance: feedViewModel.myEgpBalance,
          friendUsdBalance: feedViewModel.friendUsdBalance,
          friendEgpBalance: feedViewModel.friendEgpBalance,
          isPrimaryUser: feedViewModel.isPrimaryUser,
          onSave: feedViewModel.addExpense,
        );
      },
      onAddExchange: () => openExchange(
        context: context,
        currentUserId: currentUserId,
        feedViewModel: feedViewModel,
      ),
      onBorrowCurrency: () {
        final friendId = feedViewModel.friendProfile?.id ?? feedViewModel.friendEmailDoc?.email;
        final friendName = feedViewModel.friendProfile?.name ?? feedViewModel.friendEmailDoc?.email;

        showBorrowDialog(
          context: context,
          currentUserId: currentUserId,
          currentUserName: feedViewModel.myProfile?.name ?? 'You',
          currentUserEmail: feedViewModel.myProfile?.email,
          friendUserId: friendId,
          friendUserName: friendName,
          friendUserEmail: feedViewModel.friendEmailDoc?.email,
          myUsdBalance: feedViewModel.myUsdBalance,
          myEgpBalance: feedViewModel.myEgpBalance,
          friendUsdBalance: feedViewModel.friendUsdBalance,
          friendEgpBalance: feedViewModel.friendEgpBalance,
          onSave: feedViewModel.addBorrow,
        );
      },
    );
  }
}
