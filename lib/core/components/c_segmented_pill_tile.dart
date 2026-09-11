import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Single interactive segment tile inside SegmentedPillBar.
class SegmentedPillTile<T> extends StatelessWidget {
  final T value;
  final String label;
  final int? count;
  final IconData? icon;
  final bool isSelected;
  final bool isDark;
  final ValueChanged<T> onSelected;

  const SegmentedPillTile({
    super.key,
    required this.value,
    required this.label,
    this.count,
    this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (!isSelected) {
              HapticFeedback.selectionClick();
              onSelected(value);
            }
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16,
                    color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 5),
                ],
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: -0.2,
                    color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
                  ),
                  child: Text(label, overflow: TextOverflow.ellipsis),
                ),
                if (count != null) ...[
                  const SizedBox(width: 6),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.22)
                          : (isDark ? const Color(0xFF262A33) : const Color(0xFFE2E5EA)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : theme.colorScheme.outline,
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
  }
}
