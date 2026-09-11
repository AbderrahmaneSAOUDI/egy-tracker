import 'package:flutter/material.dart';

/// Circular tinted icon for empty state displays.
class EmptyStateIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isDark;

  const EmptyStateIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: isDark ? 0.18 : 0.12),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.5,
        ),
      ),
      child: Icon(
        icon,
        size: 26,
        color: color,
      ),
    );
  }
}
