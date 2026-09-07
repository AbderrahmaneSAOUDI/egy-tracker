import 'package:flutter/material.dart';

/// Reusable high-visibility danger button for destructive actions.
class DangerButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData icon;
  final bool isFullWidth;
  final double height;

  const DangerButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon = Icons.delete_forever_rounded,
    this.isFullWidth = true,
    this.height = 46,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18,
        color: colorScheme.error,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: colorScheme.error,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: colorScheme.error.withValues(alpha: 0.5),
          width: 1.2,
        ),
        backgroundColor:
            colorScheme.error.withValues(alpha: isDark ? 0.1 : 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: isFullWidth ? Size.fromHeight(height) : null,
      ),
    );
  }
}
