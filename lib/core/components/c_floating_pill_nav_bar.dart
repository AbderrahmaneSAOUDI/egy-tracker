import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Representation of a destination inside [FloatingPillNavBar].
class FloatingNavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const FloatingNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// A modern Google-style floating pill navigation bar.
///
/// Features:
/// - Takes the minimum size needed for its items.
/// - Floats with margins on all sides.
/// - Unselected items hide their title and show only the icon.
/// - Selected item smoothly expands horizontally with title to the right of the icon.
/// - Optional [showAddButton] displays a prominent '+' action button to the right of the nav pill.
class FloatingPillNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<FloatingNavItem> items;
  final bool showAddButton;
  final VoidCallback? onAddPressed;

  const FloatingPillNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
    this.showAddButton = false,
    this.onAddPressed,
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
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main navigation pill (taking min size of items)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainer
                    : theme.colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.50)
                        : Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.25)
                        : Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = selectedIndex == index;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Semantics(
                      button: true,
                      selected: isSelected,
                      label: item.label,
                      child: Tooltip(
                        message: item.label,
                        child: InkWell(
                          key: ValueKey(
                            'nav_item_${item.label.toLowerCase().replaceAll(' ', '_')}',
                          ),
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
                              horizontal: isSelected ? 15 : 12,
                              vertical: 8,
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
                }),
              ),
            ),

            // Animated Add Button to the right with smooth fade in/out and scale
            AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 360),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.65, end: 1.0).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: showAddButton
                    ? Padding(
                        key: const ValueKey('nav_add_button_container'),
                        padding: const EdgeInsets.only(left: 10),
                        child: _buildAddButton(theme, isDark),
                      )
                    : const SizedBox.shrink(
                        key: ValueKey('nav_add_button_hidden'),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(ThemeData theme, bool isDark) {
    final primaryColor = theme.colorScheme.primary;

    return Semantics(
      button: true,
      label: 'Add',
      child: Tooltip(
        message: 'Add',
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: isDark ? 0.45 : 0.30),
                blurRadius: 16,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.30)
                    : Colors.black.withValues(alpha: 0.08),
                blurRadius: 6,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: const ValueKey('nav_add_button'),
              onTap: () {
                HapticFeedback.lightImpact();
                onAddPressed?.call();
              },
              customBorder: const CircleBorder(),
              splashColor: Colors.white.withValues(alpha: 0.25),
              highlightColor: Colors.white.withValues(alpha: 0.12),
              child: Icon(
                Icons.add_rounded,
                color: theme.colorScheme.onPrimary,
                size: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
