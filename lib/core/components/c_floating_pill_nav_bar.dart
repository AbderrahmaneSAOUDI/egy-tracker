import 'package:flutter/material.dart';
import 'nav/c_animated_zoom_button.dart';
import 'nav/c_floating_nav_item.dart';
import 'nav/c_nav_add_button.dart';
import 'nav/c_nav_center_pill.dart';
import 'nav/c_nav_exchange_button.dart';

export 'nav/c_floating_nav_item.dart';

/// Floating navigation bar with smooth pill animations and optional quick actions.
class FloatingPillNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<FloatingNavItem> items;
  final VoidCallback? onAddPressed;
  final VoidCallback? onExchangePressed;
  final bool showAddButton;
  final bool showExchangeButton;

  const FloatingPillNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
    this.onAddPressed,
    this.onExchangePressed,
    this.showAddButton = true,
    this.showExchangeButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;
    final unselectedColor = theme.colorScheme.onSurfaceVariant;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: Animated 3D Glass Exchange Button (zoom in/out)
            AnimatedZoomButton(
              visible: showExchangeButton,
              isLeft: true,
              child: buildNavExchangeButton(
                isDark: isDark,
                onExchangePressed: onExchangePressed,
              ),
            ),

            // Center: Main navigation pill
            buildNavCenterPill(
              context: context,
              items: items,
              selectedIndex: selectedIndex,
              isDark: isDark,
              primaryColor: primaryColor,
              unselectedColor: unselectedColor,
              onDestinationSelected: onDestinationSelected,
            ),

            // Right: Animated 3D Glass Add Button (zoom in/out)
            AnimatedZoomButton(
              visible: showAddButton,
              isLeft: false,
              child: buildNavAddButton(
                theme: theme,
                isDark: isDark,
                onAddPressed: onAddPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
