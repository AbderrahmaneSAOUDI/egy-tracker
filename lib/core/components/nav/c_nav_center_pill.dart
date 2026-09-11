import 'package:flutter/material.dart';
import 'c_floating_nav_item.dart';
import 'c_nav_tab_item.dart';

Widget buildNavCenterPill({
  required BuildContext context,
  required List<FloatingNavItem> items,
  required int selectedIndex,
  required bool isDark,
  required Color primaryColor,
  required Color unselectedColor,
  required ValueChanged<int> onDestinationSelected,
}) {
  return Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1B1F27) : Colors.white,
      borderRadius: BorderRadius.circular(32),
      border: Border.all(
        color: isDark ? Colors.white.withValues(alpha: 0.16) : Colors.black.withValues(alpha: 0.08),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.85),
          blurRadius: 1,
          offset: const Offset(0, -1),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(items.length, (index) {
        return buildNavTabItem(
          item: items[index],
          index: index,
          isSelected: selectedIndex == index,
          isDark: isDark,
          primaryColor: primaryColor,
          unselectedColor: unselectedColor,
          onDestinationSelected: onDestinationSelected,
        );
      }),
    ),
  );
}
