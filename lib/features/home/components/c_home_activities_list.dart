import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
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
      );
    }

    return ListView.builder(
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
    );
  }
}
