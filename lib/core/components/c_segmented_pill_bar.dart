import 'package:flutter/material.dart';
import 'c_segmented_pill_tile.dart';

export 'c_segmented_pill_tile.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIndex = items.indexWhere((it) => it.value == selectedValue);
    final safeIndex = selectedIndex >= 0 ? selectedIndex : 0;
    final count = items.length;
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
          Row(
            children: items.map((item) {
              return SegmentedPillTile<T>(
                value: item.value,
                label: item.label,
                count: item.count,
                icon: item.icon,
                isSelected: item.value == selectedValue,
                isDark: isDark,
                onSelected: onValueChanged,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
