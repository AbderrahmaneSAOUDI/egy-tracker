import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/animations/a_staggered_item.dart';
import '../../../core/components/c_activity_tile.dart';
import '../../../core/components/c_empty_state.dart';
import '../../../core/models/mod_activity_item.dart';
import '../../../core/models/mod_expense.dart';
import '../vm_my_tracker.dart';
import 'c_my_tracker_actions.dart';

/// Scrollable list of personal expenses in My Tracker.
class MyTrackerExpenseList extends StatelessWidget {
  final List<Expense> expenses;
  final User user;
  final String? friendName;
  final MyTrackerViewModel viewModel;

  const MyTrackerExpenseList({
    super.key,
    required this.expenses,
    required this.user,
    required this.friendName,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (expenses.isEmpty) {
      return const SingleChildScrollView(
        key: ValueKey('my_tracker_list_view'),
        padding: EdgeInsets.fromLTRB(12, 0, 12, 90),
        child: EmptyState(
          icon: Icons.receipt_long_outlined,
          title: 'No personal expenses yet',
          subtitle: 'Expenses where you have a personal share will appear here.',
        ),
      );
    }

    return ListView.builder(
      key: const ValueKey('my_tracker_list_view'),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 90),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final exp = expenses[index];
        final share = viewModel.calculateUserShare(exp);
        return StaggeredItem(
          index: index,
          child: ActivityTile(
            key: ValueKey('tracker_exp_${exp.id}'),
            item: ActivityItem.expense(exp),
            currentUserId: user.uid,
            currentUserEmail: user.email,
            friendName: friendName,
            personalShare: share,
            isMyTrackerView: true,
            isPrimaryUser: viewModel.isPrimaryUser,
            onEdit: () => MyTrackerActions.openEditExpenseDialog(
              context: context,
              expense: exp,
              currentUserId: user.uid,
              viewModel: viewModel,
            ),
            onDelete: () => MyTrackerActions.openDeleteExpenseDialog(
              context: context,
              expense: exp,
              viewModel: viewModel,
            ),
          ),
        );
      },
    );
  }
}
