import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'c_floating_nav_item.dart';

Widget buildNavTabItem({
  required FloatingNavItem item,
  required int index,
  required bool isSelected,
  required bool isDark,
  required Color primaryColor,
  required Color unselectedColor,
  required ValueChanged<int> onDestinationSelected,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: Tooltip(
        message: item.label,
        child: InkWell(
          key: ValueKey('nav_item_${item.label.toLowerCase().replaceAll(' ', '_')}'),
          onTap: () {
            HapticFeedback.selectionClick();
            onDestinationSelected(index);
          },
          borderRadius: BorderRadius.circular(24),
          splashColor: primaryColor.withValues(alpha: 0.12),
          highlightColor: primaryColor.withValues(alpha: 0.06),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 380),
            curve: Curves.easeInOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: isSelected ? 14 : 11,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor.withValues(alpha: isDark ? 0.22 : 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isSelected
                    ? primaryColor.withValues(alpha: isDark ? 0.35 : 0.20)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? item.selectedIcon : item.icon,
                  size: 22,
                  color: isSelected ? primaryColor : unselectedColor,
                ),
                ClipRect(
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 380),
                    curve: Curves.easeInOutCubic,
                    child: isSelected
                        ? AnimatedOpacity(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeInOutCubic,
                            opacity: isSelected ? 1.0 : 0.0,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 7),
                                Text(
                                  item.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
