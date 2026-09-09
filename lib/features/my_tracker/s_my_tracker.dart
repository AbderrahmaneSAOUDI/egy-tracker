import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/animations/a_staggered_item.dart';
import '../../core/components/c_activity_tile.dart';
import '../../core/components/c_add_expense_dialog.dart';
import '../../core/components/c_delete_activity_dialog.dart';
import '../../core/components/c_empty_state.dart';
import '../../core/components/c_segmented_pill_bar.dart';
import '../../core/components/c_traveler_balance_card.dart';
import '../../core/models/mod_activity_item.dart';
import '../../core/models/mod_expense.dart';
import '../../core/services/f_firestore.dart';
import '../../core/utils/m_auth_helpers.dart';
import '../home/vm_home_feed.dart';
import 'vm_my_tracker.dart';

/// Screen (View) for "My Tracker" tab.
///
/// Answers:
/// "What money do I currently have, and what is my share of personal & shared expenses?"
///
/// Features:
/// - Personal physical cash balances (USD and EGP separate, zero cross-currency pollution).
/// - Modern animated segmented pill bar for fast filtering between All, Mine (100%), and Shared.
/// - Single unified, uninterrupted expense feed with personal consumption shares and slide actions.
class MyTrackerScreen extends StatefulWidget {
  final User user;
  final FirestoreService firestoreService;
  final HomeFeedViewModel? feedViewModel;
  final MyTrackerViewModel? viewModel;

  const MyTrackerScreen({
    super.key,
    required this.user,
    required this.firestoreService,
    this.feedViewModel,
    this.viewModel,
  });

  @override
  State<MyTrackerScreen> createState() => _MyTrackerScreenState();
}

class _MyTrackerScreenState extends State<MyTrackerScreen> {
  late final MyTrackerViewModel _viewModel;
  bool _ownsViewModel = false;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
    } else {
      _viewModel = MyTrackerViewModel(
        user: widget.user,
        firestoreService: widget.firestoreService,
        feedViewModel: widget.feedViewModel,
      );
      _ownsViewModel = true;
    }
  }

  @override
  void dispose() {
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  void _openEditExpenseDialog(BuildContext context, Expense expense) {
    final friendId = _viewModel.friendProfile?.id ?? _viewModel.friendEmailDoc?.email;
    final friendName = _viewModel.friendProfile?.name ?? _viewModel.friendEmailDoc?.email;

    showAddExpenseDialog(
      context: context,
      currentUserId: widget.user.uid,
      currentUserName: _viewModel.myProfile?.name ?? 'You',
      friendUserId: friendId,
      friendUserName: friendName,
      myUsdBalance: _viewModel.myUsdBalance,
      myEgpBalance: _viewModel.myEgpBalance,
      friendUsdBalance: 0.0,
      friendEgpBalance: 0.0,
      initialExpense: expense,
      onSave: (updated) => _viewModel.updateExpense(updated),
    );
  }

  void _openDeleteExpenseDialog(BuildContext context, Expense expense) {
    showDeleteActivityDialog(
      context: context,
      item: ActivityItem.expense(expense),
      onDelete: () => _viewModel.deleteExpense(expense.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final myName = resolveUserName(widget.user, _viewModel.myProfile?.name);
        final myPhoto = resolveUserPhoto(widget.user, _viewModel.myProfile?.photoUrl);
        final friendName = _viewModel.friendProfile?.name.isNotEmpty == true
            ? _viewModel.friendProfile!.name
            : _viewModel.friendEmailDoc?.email;

        final filter = _viewModel.filter;
        final myExpenses = _viewModel.myExpenses;
        final sharedExpenses = _viewModel.sharedExpenses;
        final allExpenses = _viewModel.allPersonalExpenses;

        // Select the active list according to the active filter
        final List<Expense> activeExpenses;
        if (filter == MyTrackerFilter.myExpenses) {
          activeExpenses = myExpenses;
        } else if (filter == MyTrackerFilter.sharedExpenses) {
          activeExpenses = sharedExpenses;
        } else {
          activeExpenses = allExpenses;
        }

        return ListView(
          key: const ValueKey('my_tracker_list_view'),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          children: [
            // ===================== SECTION 1: PERSONAL CASH BALANCES =====================
            TravelerBalanceCard(
              name: myName,
              photoUrl: myPhoto,
              email: widget.user.email ?? '',
              isCurrentUser: true,
              usdAmount: _viewModel.myUsdBalance,
              egpAmount: _viewModel.myEgpBalance,
            ),
            const SizedBox(height: 16),

            // ===================== SECTION 2: ANIMATED SEGMENTED FILTER =====================
            SegmentedPillBar<MyTrackerFilter>(
              selectedValue: filter,
              onValueChanged: _viewModel.setFilter,
              items: [
                SegmentedPillItem(
                  value: MyTrackerFilter.all,
                  label: 'All',
                  count: allExpenses.length,
                ),
                SegmentedPillItem(
                  value: MyTrackerFilter.myExpenses,
                  label: 'Mine',
                  count: myExpenses.length,
                ),
                SegmentedPillItem(
                  value: MyTrackerFilter.sharedExpenses,
                  label: 'Shared',
                  count: sharedExpenses.length,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ===================== SECTION 3: UNIFIED EXPENSE LIST =====================
            if (activeExpenses.isEmpty)
              EmptyState(
                icon: filter == MyTrackerFilter.sharedExpenses
                    ? Icons.group_outlined
                    : Icons.receipt_long_outlined,
                title: filter == MyTrackerFilter.sharedExpenses
                    ? 'No shared expenses'
                    : (filter == MyTrackerFilter.myExpenses
                        ? 'No 100% personal expenses'
                        : 'No personal expenses yet'),
                subtitle: 'Expenses where you have a personal share will appear here.',
              )
            else
              ...activeExpenses.asMap().entries.map((entry) {
                final exp = entry.value;
                final share = _viewModel.calculateUserShare(exp);
                return StaggeredItem(
                  index: entry.key,
                  child: ActivityTile(
                    key: ValueKey('tracker_exp_${exp.id}'),
                    item: ActivityItem.expense(exp),
                    currentUserId: widget.user.uid,
                    friendName: friendName,
                    personalShare: share,
                    isMyTrackerView: true,
                    onEdit: () => _openEditExpenseDialog(context, exp),
                    onDelete: () => _openDeleteExpenseDialog(context, exp),
                  ),
                );
              }),
          ],
        );
      },
    );
  }
}
