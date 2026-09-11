import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/animations/a_shimmer.dart';
import '../../../core/animations/a_staggered_item.dart';
import '../../../core/components/c_activity_tile.dart';
import '../../../core/components/c_empty_state.dart';
import '../../../core/models/mod_activity_item.dart';
import '../vm_home_feed.dart';
import 'c_home_tab_actions.dart';

/// Scrollable list of activities or empty state for the Home tab.
class HomeActivitiesList extends StatelessWidget {
  final List<ActivityItem> activities;
  final HomeFeedFilter filter;
  final User user;
  final String? friendName;
  final HomeFeedViewModel viewModel;

  const HomeActivitiesList({
    super.key,
    required this.activities,
    required this.filter,
    required this.user,
    required this.friendName,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      if (viewModel.isLoading) {
        return const _ActivityListSkeleton();
      }

      return SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 90),
          child: EmptyState(
            icon: filter == HomeFeedFilter.split
                ? Icons.group_outlined
                : (filter == HomeFeedFilter.friend
                    ? Icons.person_outline_rounded
                    : Icons.receipt_long_outlined),
            title: filter == HomeFeedFilter.split
                ? 'No split activities'
                : (filter == HomeFeedFilter.friend
                    ? 'No friend activities'
                    : 'No activity yet'),
            subtitle: 'Activities will appear here once recorded.',
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 90),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
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
                onEdit: () => HomeTabActions.editItem(
                  context: context,
                  item: item,
                  user: user,
                  viewModel: viewModel,
                ),
                onDelete: () => HomeTabActions.confirmDelete(
                  context: context,
                  item: item,
                  viewModel: viewModel,
                ),
              ),
            );
          },
          childCount: activities.length,
        ),
      ),
    );
  }
}

class _ActivityListSkeleton extends StatelessWidget {
  const _ActivityListSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.08);

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 90),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Shimmer(
                child: Container(
                  height: 68,
                  decoration: BoxDecoration(
                    color: placeholderColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            );
          },
          childCount: 4,
        ),
      ),
    );
  }
}
