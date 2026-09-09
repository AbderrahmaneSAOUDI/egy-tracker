import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Representation of an individual item in [SegmentedPillBar].
class SegmentedPillItem<T> {
  final T value;
  final String label;
  final int? count;
  final IconData? icon;

  const SegmentedPillItem({
    required this.value,
    required this.label,
    this.count,
    this.icon,
  });
}

/// A modern, fintech-styled segmented pill bar with smooth sliding indicator animations.
///
/// Features:
/// - Floating rounded container with subtle glassmorphism border and elevation.
/// - Fluid animated indicator sliding seamlessly behind the active segment.
/// - Dynamic count badges that highlight on active selection.
/// - Haptic feedback on segment changes.
class SegmentedPillBar<T> extends StatelessWidget {
  final List<SegmentedPillItem<T>> items;
  final T selectedValue;
  final ValueChanged<T> onValueChanged;
  final Duration duration;
  final Curve curve;

  const SegmentedPillBar({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onValueChanged,
    this.duration = const Duration(milliseconds: 260),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    assert(items.isNotEmpty);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedIndex = items.indexWhere((it) => it.value == selectedValue);
    final safeIndex = selectedIndex >= 0 ? selectedIndex : 0;
    final count = items.length;

    // Calculate alignment for index: -1.0 (left) to 1.0 (right)
    final double alignX = count > 1 ? -1.0 + (2.0 * safeIndex) / (count - 1) : 0.0;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF17191E) : const Color(0xFFF1F3F6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? const Color(0xFF2A2E37) : const Color(0xFFE2E5EA),
          width: 1.1,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Stack(
        children: [
          // 1. Sliding indicator
          AnimatedAlign(
            duration: duration,
            curve: curve,
            alignment: Alignment(alignX, 0.0),
            child: FractionallySizedBox(
              widthFactor: 1.0 / count,
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),

          // 2. Segment items row
          Row(
            children: items.map((item) {
              final isSelected = item.value == selectedValue;

              return Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (!isSelected) {
                        HapticFeedback.selectionClick();
                        onValueChanged(item.value);
                      }
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item.icon != null) ...[
                            Icon(
                              item.icon,
                              size: 16,
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 5),
                          ],
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 180),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              letterSpacing: -0.2,
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            child: Text(
                              item.label,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (item.count != null) ...[
                            const SizedBox(width: 6),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.22)
                                    : (isDark
                                        ? const Color(0xFF262A33)
                                        : const Color(0xFFE2E5EA)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${item.count}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : theme.colorScheme.outline,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
