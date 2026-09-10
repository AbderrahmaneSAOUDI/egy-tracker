import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/t_app_theme.dart';

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

/// A modern Google-style floating pill navigation bar with 3D glassmorphism.
///
/// Features:
/// - Floating with margins on all sides and frosted glass surface.
/// - Unselected items hide their title and show only the icon.
/// - Selected item smoothly expands horizontally with title to the right of the icon.
/// - Optional [showExchangeButton] displays a 3D glass 'Add Exchange' action button to the left.
/// - Optional [showAddButton] displays a 3D glass '+' action button to the right.
/// - Both action buttons feature silky-smooth zoom in/out scale animations without fade or slide.
class FloatingPillNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<FloatingNavItem> items;
  final bool showAddButton;
  final VoidCallback? onAddPressed;
  final bool showExchangeButton;
  final VoidCallback? onExchangePressed;

  const FloatingPillNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
    this.showAddButton = false,
    this.onAddPressed,
    this.showExchangeButton = false,
    this.onExchangePressed,
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
            _AnimatedZoomButton(
              visible: showExchangeButton,
              isLeft: true,
              child: _buildExchangeButton(theme, isDark),
            ),

            // Center: Main navigation pill with 3D glassmorphism
            ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1B1F27).withValues(alpha: 0.88)
                        : Colors.white.withValues(alpha: 0.88),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.16)
                          : Colors.black.withValues(alpha: 0.08),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.white.withValues(alpha: 0.85),
                        blurRadius: 1,
                        offset: const Offset(0, -1),
                      ),
                    ],
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
                                      ? primaryColor.withValues(
                                          alpha: isDark ? 0.22 : 0.12)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isSelected
                                        ? primaryColor.withValues(
                                            alpha: isDark ? 0.35 : 0.20)
                                        : Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isSelected
                                          ? item.selectedIcon
                                          : item.icon,
                                      size: 22,
                                      color: isSelected
                                          ? primaryColor
                                          : unselectedColor,
                                    ),
                                    ClipRect(
                                      child: AnimatedSize(
                                        duration:
                                            const Duration(milliseconds: 380),
                                        curve: Curves.easeInOutCubic,
                                        child: isSelected
                                            ? AnimatedOpacity(
                                                duration: const Duration(
                                                    milliseconds: 320),
                                                curve: Curves.easeInOutCubic,
                                                opacity:
                                                    isSelected ? 1.0 : 0.0,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const SizedBox(width: 7),
                                                    Text(
                                                      item.label,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.clip,
                                                      style: TextStyle(
                                                        color: primaryColor,
                                                        fontWeight:
                                                            FontWeight.w700,
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
              ),
            ),

            // Right: Animated 3D Glass Add Button (zoom in/out)
            _AnimatedZoomButton(
              visible: showAddButton,
              isLeft: false,
              child: _buildAddButton(theme, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExchangeButton(ThemeData theme, bool isDark) {
    final exchangeColor = isDark ? AppTheme.googleBlueDark : AppTheme.googleBlue;

    return Semantics(
      button: true,
      label: 'Add Exchange',
      child: Tooltip(
        message: 'Add Exchange',
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                exchangeColor,
                exchangeColor.withValues(alpha: 0.88),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.28)
                  : Colors.white.withValues(alpha: 0.70),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: exchangeColor.withValues(alpha: isDark ? 0.45 : 0.35),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: isDark ? 0.20 : 0.45),
                blurRadius: 2,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: const ValueKey('nav_exchange_button'),
              onTap: () {
                HapticFeedback.lightImpact();
                onExchangePressed?.call();
              },
              customBorder: const CircleBorder(),
              splashColor: Colors.white.withValues(alpha: 0.25),
              highlightColor: Colors.white.withValues(alpha: 0.12),
              child: const Icon(
                Icons.sync_alt_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
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
            gradient: LinearGradient(
              colors: [
                primaryColor,
                primaryColor.withValues(alpha: 0.88),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.28)
                  : Colors.white.withValues(alpha: 0.70),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: isDark ? 0.45 : 0.35),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: isDark ? 0.20 : 0.45),
                blurRadius: 2,
                offset: const Offset(0, -1),
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
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Zoom in/out animated button wrapper for bottom nav action buttons.
/// Pure scale transition with zero fade or slide, and organic size collapse.
class _AnimatedZoomButton extends StatefulWidget {
  final bool visible;
  final bool isLeft;
  final Widget child;

  const _AnimatedZoomButton({
    required this.visible,
    required this.isLeft,
    required this.child,
  });

  @override
  State<_AnimatedZoomButton> createState() => _AnimatedZoomButtonState();
}

class _AnimatedZoomButtonState extends State<_AnimatedZoomButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.visible ? 1.0 : 0.0,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void didUpdateWidget(covariant _AnimatedZoomButton oldWidget) {
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
    final hiddenKey = ValueKey(
      widget.isLeft ? 'nav_exchange_button_hidden' : 'nav_add_button_hidden',
    );
    final containerKey = ValueKey(
      widget.isLeft ? 'nav_exchange_button_container' : 'nav_add_button_container',
    );

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, _) {
        if (_controller.isDismissed && !widget.visible) {
          return SizedBox.shrink(key: hiddenKey);
        }

        return ClipRect(
          child: Align(
            alignment:
                widget.isLeft ? Alignment.centerRight : Alignment.centerLeft,
            widthFactor: _scaleAnimation.value.clamp(0.0, 1.0),
            heightFactor: 1.0,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                key: containerKey,
                padding: widget.isLeft
                    ? const EdgeInsets.only(right: 8)
                    : const EdgeInsets.only(left: 8),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}
