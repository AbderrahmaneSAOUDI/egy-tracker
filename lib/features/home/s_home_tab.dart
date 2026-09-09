import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/animations/a_staggered_item.dart';
import '../../core/components/c_empty_state.dart';
import '../../core/components/c_icon_badge.dart';
import '../../core/utils/m_auth_helpers.dart';
import '../../core/components/c_activity_tile.dart';
import '../../core/components/c_add_exchange_dialog.dart';
import '../../core/components/c_add_expense_dialog.dart';
import '../../core/components/c_borrow_dialog.dart';
import '../../core/components/c_delete_activity_dialog.dart';
import '../../core/models/mod_activity_item.dart';
import 'components/c_home_balances_card.dart';
import 'vm_home_feed.dart';

/// Screen (View) for the Home tab displaying current balances and recent activity feed.
class HomeTabScreen extends StatelessWidget {
  final User user;
  final HomeFeedViewModel viewModel;

  const HomeTabScreen({
    super.key,
    required this.user,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final myName = resolveUserName(user, viewModel.myProfile?.name);
        final myPhoto = resolveUserPhoto(user, viewModel.myProfile?.photoUrl);
        final friendName = viewModel.friendProfile?.name.isNotEmpty == true
            ? viewModel.friendProfile!.name
            : viewModel.friendEmailDoc?.email;
        final friendPhoto = viewModel.friendProfile?.photoUrl;
        final friendEmail = viewModel.friendEmailDoc?.email;

        final activities = viewModel.activities;

        return RefreshIndicator(
          onRefresh: viewModel.refresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              // ===================== SECTION 1: BALANCES CARD =====================
              HomeBalancesCard(
                myName: myName,
                myPhotoUrl: myPhoto,
                myEmail: user.email ?? '',
                myUsd: viewModel.myUsdBalance,
                myEgp: viewModel.myEgpBalance,
                friendName: friendName,
                friendPhotoUrl: friendPhoto,
                friendEmail: friendEmail,
                friendUsd: viewModel.friendUsdBalance,
                friendEgp: viewModel.friendEgpBalance,
              ),
              const SizedBox(height: 24),

              // ===================== SECTION 2: RECENT ACTIVITY HEADER =====================
              Row(
                children: [
                  const IconBadge(
                    icon: Icons.history_rounded,
                    size: 32,
                    iconSize: 18,
                    borderRadius: 10,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.2,
                    ),
                  ),
                  if (activities.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${activities.length}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // ===================== SECTION 3: ACTIVITY FEED OR EMPTY STATE =====================
              if (activities.isEmpty)
                EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'No activity yet',
                  action: FilledButton.tonalIcon(
                    onPressed: () {
                      final friendId = viewModel.friendProfile?.id ??
                          viewModel.friendEmailDoc?.email;
                      final friendUserName = viewModel.friendProfile?.name ??
                          viewModel.friendEmailDoc?.email;
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
                        onSave: viewModel.addExpense,
                      );
                    },
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Expense'),
                  ),
                )
              else
                ...activities.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return StaggeredItem(
                    key: ValueKey('staggered_${item.id}'),
                    index: index,
                    child: ActivityTile(
                      key: ValueKey('activity_${item.id}'),
                      item: item,
                      currentUserId: user.uid,
                      friendName: friendName,
                      onEdit: () => _editItem(context, item),
                      onDelete: () => _confirmDelete(context, item),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  void _editItem(BuildContext context, ActivityItem item) {
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
        friendUserId: friendId,
        friendUserName: friendUserName,
        initialBorrow: item.borrow,
        onSave: viewModel.updateBorrow,
      );
    }
  }

  void _confirmDelete(BuildContext context, ActivityItem item) {
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
