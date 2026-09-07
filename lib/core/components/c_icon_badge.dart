import 'package:flutter/material.dart';

/// Reusable icon badge container with consistent padding, rounded border,
/// and responsive dark/light alpha tinting.
class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double size;
  final double iconSize;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;

  const IconBadge({
    super.key,
    required this.icon,
    this.color,
    this.size = 38,
    this.iconSize = 20,
    this.borderRadius = 11,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveColor = color ?? theme.colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ??
            effectiveColor.withValues(alpha: isDark ? 0.20 : 0.10),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ??
              effectiveColor.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        size: iconSize,
        color: effectiveColor,
      ),
    );
  }
}
