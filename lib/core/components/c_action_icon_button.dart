import 'package:flutter/material.dart';

/// Reusable tinted icon button with rounded corners and border.
class ActionIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final String? tooltip;
  final double iconSize;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  const ActionIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.tooltip,
    this.iconSize = 20,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(10),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final effectiveColor = color ?? colorScheme.primary;

    Widget button = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: isDark ? 0.14 : 0.08),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: effectiveColor.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: iconSize,
            color: effectiveColor,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
