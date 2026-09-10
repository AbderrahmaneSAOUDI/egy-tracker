import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/animations/a_staggered_item.dart';
import '../../core/components/c_empty_state.dart';
import '../../core/utils/m_auth_helpers.dart';
import '../../core/components/c_activity_tile.dart';
import '../../core/components/c_add_exchange_dialog.dart';
import '../../core/components/c_add_expense_dialog.dart';
import '../../core/components/c_borrow_dialog.dart';
import '../../core/components/c_delete_activity_dialog.dart';
import '../../core/components/c_segmented_pill_bar.dart';
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

        final activities = viewModel.filteredActivities;

        return RefreshIndicator(
          onRefresh: viewModel.refresh,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                    const SizedBox(height: 10),

                    // ===================== SECTION 2: ANIMATED SEGMENTED FILTER =====================
                    SegmentedPillBar<HomeFeedFilter>(
                      selectedValue: viewModel.filter,
                      onValueChanged: viewModel.setFilter,
                      items: [
                        SegmentedPillItem(
                          value: HomeFeedFilter.all,
                          label: 'All',
                          count: viewModel.allActivities.length,
                        ),
                        SegmentedPillItem(
                          value: HomeFeedFilter.mine,
                          label: 'Mine',
                          count: viewModel.mineActivities.length,
                        ),
                        SegmentedPillItem(
                          value: HomeFeedFilter.shared,
                          label: 'Shared',
                          count: viewModel.sharedActivities.length,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              // ===================== SECTION 3: SCROLLABLE ITEMS LIST CONTAINER =====================
              Expanded(
                child: activities.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 90),
                        child: EmptyState(
                          icon: viewModel.filter == HomeFeedFilter.shared
                              ? Icons.group_outlined
                              : Icons.receipt_long_outlined,
                          title: viewModel.filter == HomeFeedFilter.shared
                              ? 'No shared activities'
                              : (viewModel.filter == HomeFeedFilter.mine
                                  ? 'No personal activities'
                                  : 'No activity yet'),
                          subtitle: 'Activities will appear here once recorded.',
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 90),
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final item = activities[index];
                          return StaggeredItem(
                            key: ValueKey('staggered_${item.id}'),
                            index: index,
                            child: ActivityTile(
                              key: ValueKey('activity_${item.id}'),
                              item: item,
                              currentUserId: user.uid,
                              currentUserEmail: user.email,
                              friendName: friendName,
                              isPrimaryUser: viewModel.isPrimaryUser,
                              onEdit: () => _editItem(context, item),
                              onDelete: () => _confirmDelete(context, item),
                            ),
                          );
                        },
                      ),
              ),
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
