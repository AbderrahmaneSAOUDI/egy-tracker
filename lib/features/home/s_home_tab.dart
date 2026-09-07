import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/components/c_empty_state.dart';
import '../../core/components/c_icon_badge.dart';
import '../../core/utils/m_auth_helpers.dart';
import 'components/c_activity_tile.dart';
import 'components/c_home_balances_card.dart';
import 'models/mod_activity_item.dart';
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

        return ListView(
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
            const Row(
              children: [
                IconBadge(
                  icon: Icons.history_rounded,
                  size: 32,
                  iconSize: 18,
                  borderRadius: 10,
                ),
                SizedBox(width: 10),
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ===================== SECTION 3: ACTIVITY FEED OR EMPTY STATE =====================
            if (activities.isEmpty)
              const EmptyState(
                icon: Icons.receipt_long_outlined,
                title: 'No activity yet',
              )
            else
              ...activities.map((item) {
                return ActivityTile(
                  key: ValueKey('activity_${item.id}'),
                  item: item,
                  currentUserId: user.uid,
                  friendName: friendName,
                  onDelete: () => _confirmDelete(context, item),
                );
              }),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, ActivityItem item) {
    String title;
    String name;
    if (item.isExpense) {
      title = 'Delete Expense';
      name = item.expense!.title;
    } else if (item.isExchange) {
      title = 'Delete Exchange';
      name = 'this exchange';
    } else {
      title = 'Delete Borrow Record';
      name = 'this borrow record';
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text('Are you sure you want to delete "$name"? Cash balances will be updated.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                if (item.isExpense) {
                  await viewModel.deleteExpense(item.id);
                } else if (item.isExchange) {
                  await viewModel.deleteExchange(item.id);
                } else {
                  await viewModel.deleteBorrow(item.id);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
