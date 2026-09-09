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
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Main navigation pill (taking min size of items)
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surfaceContainer
                    : theme.colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                }),
              ),
            ),

            // Animated Add Button with smooth fade-in/out, scale, and width collapse
            _AnimatedAddButton(
              visible: showAddButton,
              child: _buildAddButton(theme, isDark),
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
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.08),
              width: 1,
            ),
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
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedAddButton extends StatefulWidget {
  final bool visible;
  final Widget child;

  const _AnimatedAddButton({
    required this.visible,
    required this.child,
  });

  @override
  State<_AnimatedAddButton> createState() => _AnimatedAddButtonState();
}

class _AnimatedAddButtonState extends State<_AnimatedAddButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      value: widget.visible ? 1.0 : 0.0,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void didUpdateWidget(covariant _AnimatedAddButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        if (_controller.isDismissed && !widget.visible) {
          return const SizedBox.shrink(key: ValueKey('nav_add_button_hidden'));
        }

        return ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: _animation.value,
            heightFactor: 1.0,
            child: Opacity(
              opacity: _animation.value.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: 0.75 + (0.25 * _animation.value),
                child: Padding(
                  key: const ValueKey('nav_add_button_container'),
                  padding: const EdgeInsets.only(left: 8),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
