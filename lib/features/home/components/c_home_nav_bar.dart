import 'package:flutter/material.dart';
import '../../../core/components/c_floating_pill_nav_bar.dart';
import '../vm_home_feed.dart';
import 'c_home_action_handler.dart';

/// Navigation bar component for the home screen scaffold.
class HomeNavBar extends StatelessWidget {
  final int selectedIndex;
  final String currentUserId;
  final HomeFeedViewModel feedViewModel;
  final ValueChanged<int> onDestinationSelected;

  const HomeNavBar({
    super.key,
    required this.selectedIndex,
    required this.currentUserId,
    required this.feedViewModel,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final showActions = selectedIndex == 0 || selectedIndex == 1;
    return FloatingPillNavBar(
      selectedIndex: selectedIndex,
      showAddButton: showActions,
      showExchangeButton: showActions,
      onExchangePressed: () => HomeActionHandler.openExchange(
        context: context,
        currentUserId: currentUserId,
        feedViewModel: feedViewModel,
      ),
      onAddPressed: () => HomeActionHandler.openAddSheet(
        context: context,
        currentUserId: currentUserId,
        feedViewModel: feedViewModel,
      ),
      onDestinationSelected: onDestinationSelected,
      items: const [
        FloatingNavItem(
          icon: Icons.home_outlined,
          selectedIcon: Icons.home_rounded,
          label: 'Home',
        ),
        FloatingNavItem(
          icon: Icons.person_outline_rounded,
          selectedIcon: Icons.person_rounded,
          label: 'My Tracker',
        ),
        FloatingNavItem(
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings_rounded,
          label: 'Settings',
        ),
      ],
    );
  }
}
