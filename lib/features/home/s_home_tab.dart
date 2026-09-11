import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/components/c_segmented_pill_bar.dart';
import '../../core/utils/m_auth_helpers.dart';
import 'components/c_home_activities_list.dart';
import 'components/c_home_balances_card.dart';
import 'vm_home_feed.dart';

export 'components/c_home_activities_list.dart';
export 'components/c_home_balances_card.dart';
export 'components/c_home_tab_actions.dart';

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
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (viewModel.errorMessage != null) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline,
                                  size: 18,
                                  color: Theme.of(context).colorScheme.error),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  viewModel.errorMessage!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                      SegmentedPillBar<HomeFeedFilter>(
                        selectedValue: viewModel.filter,
                        onValueChanged: viewModel.setFilter,
                        items: [
                          SegmentedPillItem(value: HomeFeedFilter.all, label: 'All', count: viewModel.allActivities.length),
                          SegmentedPillItem(value: HomeFeedFilter.friend, label: 'Friend', count: viewModel.friendActivities.length),
                          SegmentedPillItem(value: HomeFeedFilter.split, label: 'Split', count: viewModel.splitActivities.length),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              HomeActivitiesList(
                activities: activities,
                filter: viewModel.filter,
                user: user,
                friendName: friendName,
                viewModel: viewModel,
              ),
            ],
          ),
        );
      },
    );
  }
}
